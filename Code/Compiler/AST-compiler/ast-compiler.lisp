(cl:in-package #:sicl-compiler)

(defun compile-ast (client ast)
  (eliminate-fdefinition-asts ast)
  (let* ((cleavir-cst-to-ast::*origin* nil)
         (hoisted-ast (cleavir-ast-transformations:hoist-load-time-value ast))
         (parameter-ast
           (make-instance 'cleavir-ast:lexical-ast
             :name (gensym)))
         (wrapped-ast (make-instance 'cleavir-ast:function-ast
                        :lambda-list (list parameter-ast)
                        :body-ast hoisted-ast))
         (hir (cleavir-ast-to-hir:compile-toplevel-unhoisted client wrapped-ast))
         (code-object
           (make-instance 'code-object
             :ast ast
             :ir hir)))
    (cleavir-partial-inlining:do-inlining hir)
    (sicl-argument-processing:process-parameters hir)
    (sicl-hir-transformations:eliminate-fixed-to-multiple-instructions hir)
    (sicl-hir-transformations:eliminate-multiple-to-fixed-instructions hir)
    (cleavir-hir-transformations::process-captured-variables hir)
    ;; Replacing aliases does not appear to have a great effect when
    ;; code generation is disabled.  Try removing this commented line
    ;; when code generation is again enabled.
    ;; (cleavir-hir-transformations:replace-aliases hir)
    (sicl-hir-transformations:eliminate-create-cell-instructions hir)
    (sicl-hir-transformations:eliminate-fetch-instructions hir)
    (sicl-hir-transformations:eliminate-read-cell-instructions hir)
    (sicl-hir-transformations:eliminate-write-cell-instructions hir)
    (process-constant-inputs code-object)
    (let ((constants-vector (coerce (constants code-object) 'simple-vector)))
      (cleavir-ir:map-instructions-arbitrary-order
       (lambda (instruction)
         (when (typep instruction 'sicl-ir:load-constant-instruction)
           (setf (sicl-ir:constants instruction) constants-vector)))
       hir))
    (cleavir-remove-useless-instructions:remove-useless-instructions hir)
    (establish-call-sites code-object)
    (setf (hir-thunks code-object)
          (sicl-hir-evaluator:top-level-hir-to-host-function client hir))
    ;; (sicl-hir-transformations:eliminate-append-values-instructions hir)
    ;; (sicl-hir-to-mir:hir-to-mir client hir)
    ;; (sicl-mir-to-lir:mir-to-lir client hir)
    ;; (multiple-value-bind (instructions label-map)
    ;;   (cluster:assemble (sicl-code-generation:generate-code hir2))
    code-object))
