(cl:in-package #:cleavir-cst-to-ast)

(defmethod convert-global-function-reference (client
                                              cst
                                              info
                                              global-env)
  (declare (ignore global-env))
  (let ((name-ast (make-instance 'cleavir-ast:constant-ast
                    :value (cleavir-env:name info))))
    (make-instance 'cleavir-ast:fdefinition-ast
      :name-ast name-ast)))

(defmethod convert-function-reference (client
                                       cst
                                       (info cleavir-env:global-function-info)
                                       lexical-environment)
  (convert-global-function-reference client
                                     cst
                                     info
                                     (cleavir-env:global-environment lexical-environment)))

(defmethod convert-function-reference (client
                                       cst
                                       (info cleavir-env:local-function-info)
                                       lexical-environment)
  (declare (ignore client lexical-environment))
  (cleavir-env:identity info))

(defmethod convert-function-reference (client
                                       cst
                                       (info cleavir-env:global-macro-info)
                                       lexical-environment)
  (error 'function-name-names-global-macro
         :expr (cleavir-env:name info)))

(defmethod convert-function-reference (client
                                       cst
                                       (info cleavir-env:local-macro-info)
                                       lexical-environment)
  (error 'function-name-names-local-macro
         :expr (cleavir-env:name info)))

(defmethod convert-function-reference (client
                                       cst
                                       (info cleavir-env:special-operator-info)
                                       lexical-environment)
  (error 'function-name-names-special-operator
         :expr (cleavir-env:name info)))

;;; These are used by (foo ...) forms.
;;; It's useful to distinguish them. For instance, an implementation
;;; may bind non-fbound symbols to a function that signals an error
;;; of type UNDEFINED-FUNCTION, allowing an fboundp check to be skipped.
;;; Other than the inlining, they by default have the same behavior.

(defmethod convert-called-function-reference (client
                                              cst
                                              info
                                              lexical-environment)
  (when (not (eq (cleavir-env:inline info) 'cl:notinline))
    (let ((ast (cleavir-env:ast info)))
      (when ast
        (return-from convert-called-function-reference
          ;; The AST must be cloned because hoisting is destructive.
          (cleavir-ast-transformations:clone-ast ast)))))
  (convert-global-function-reference client
                                     cst
                                     info
                                     (cleavir-env:global-environment lexical-environment)))

(defmethod convert-called-function-reference (client
                                              cst
                                              (info cleavir-env:local-function-info)
                                              lexical-environment)
  (declare (ignore client lexical-environment))
  (cleavir-env:identity info))

(defmethod convert-called-function-reference (client
                                              cst
                                              (info cleavir-env:global-macro-info)
                                              lexical-environment)
  (error 'function-name-names-global-macro
         :expr (cleavir-env:name info)))

(defmethod convert-called-function-reference (client
                                              cst
                                              (info cleavir-env:local-macro-info)
                                              lexical-environment)
  (error 'function-name-names-local-macro
         :expr (cleavir-env:name info)))

(defmethod convert-called-function-reference (client
                                              cst
                                              (info cleavir-env:special-operator-info)
                                              lexical-environment)
  (error 'function-name-names-special-operator
         :expr (cleavir-env:name info)))
