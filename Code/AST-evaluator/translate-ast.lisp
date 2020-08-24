(cl:in-package #:sicl-ast-evaluator)

(defgeneric translate-ast (ast global-environment lexical-environment))

(defmethod translate-ast
    ((ast ast:fdefinition-ast) global-environment lexical-environment)
  `(env:fdefinition
    (client ,*run-time-environment-name*)
    ,*run-time-environment-name*
    ,(translate-ast
      (ast:name-ast ast) global-environment lexical-environment)))

(defmethod translate-ast
    ((ast ast:constant-ast) global-environment lexical-environment)
  `',(ast:value ast))

(defmethod translate-ast
    ((ast ast:lexical-ast) global-environment lexical-environment)
  (find-identifier lexical-environment ast))

(defmethod translate-ast
    ((ast ast:symbol-value-ast) global-environment lexical-environment)
  `(symbol-value
    ,(translate-ast
      (ast:name-ast ast) global-environment lexical-environment)
    ,global-environment))

(defmethod translate-ast
    ((ast ast:set-symbol-value-ast) global-environment lexical-environment)
  `(setf (symbol-value
          ,(translate-ast
            (ast:name-ast ast) global-environment lexical-environment)
          ,global-environment)
         ,(translate-ast
           (ast:value-ast ast) global-environment lexical-environment)))

(defmethod translate-ast
    ((ast ast:call-ast) global-environment lexical-environment)
  `(funcall
    ,(translate-ast (ast:callee-ast ast) global-environment lexical-environment)
    ,@(loop for argument-ast in (ast:argument-asts ast)
            collect (translate-ast
                     argument-ast global-environment lexical-environment))))

(defmethod translate-ast
    ((ast ast:function-ast) global-environment lexical-environment)
  (let* ((lambda-list (ast:lambda-list ast))
         (new-environment (augment-environment lexical-environment lambda-list)))
    `(lambda
         ,(loop for item in (ast:lambda-list ast)
                collect
                (cond ((member item lambda-list-keywords)
                       item)
                      ((atom item)
                       (find-identifier new-environment item))
                      (t
                       (loop for ast in item
                             collect (find-identifier new-environment ast)))))
       ,(translate-ast (ast:body-ast ast) global-environment new-environment))))

(defmethod translate-ast
    ((ast ast:progn-ast) global-environment lexical-environment)
  `(progn ,@(loop for form-ast in (ast:form-asts ast)
                  collect (translate-ast
                           form-ast global-environment lexical-environment))))

(defmethod translate-ast
    ((ast ast:block-ast) global-environment lexical-environment)
  (add-identifier lexical-environment ast)
  (let ((name (find-identifier lexical-environment ast)))
    `(with-exit-point (,name)
       (block ,name
         ,(translate-ast
           (ast:body-ast ast) global-environment lexical-environment)))))

(defmethod translate-ast
    ((ast ast:return-from-ast) global-environment lexical-environment)
  (let ((name (find-identifier lexical-environment (ast:block-ast ast))))
    `(progn (unwind ',name)
            (return-from ,name
              ,(translate-ast
                (ast:form-ast ast) global-environment lexical-environment)))))

(defmethod translate-ast
    ((ast ast:tagbody-ast) global-environment lexical-environment)
  (let ((name (gensym)))
    (loop for item-ast in (ast:item-asts ast)
          when (typep item-ast 'ast:tag-ast)
            do (add-identifier lexical-environment item-ast name))
    `(with-exit-point (,name)
       (tagbody
          ,(loop for item-ast in (ast:item-asts ast)
                 collect (if (typep item-ast 'ast:tag-ast)
                             (ast:name item-ast)
                             (translate-ast
                              item-ast global-environment lexical-environment)))))))

(defmethod translate-ast
    ((ast ast:go-ast) global-environment lexical-environment)
  (let ((name (find-identifier lexical-environment (ast:tag-ast ast))))
    `(progn (unwind ',name)
            (go ,name))))

(defmethod translate-ast
    ((ast ast:if-ast) global-environment lexical-environment)
  `(if ,(translate-ast (ast:test-ast ast) global-environment lexical-environment)
       ,(translate-ast (ast:then-ast ast) global-environment lexical-environment)
       ,(translate-ast (ast:else-ast ast) global-environment lexical-environment)))

(defmethod translate-ast
    ((ast ast:eq-ast) global-environment lexical-environment)
  `(eq ,(translate-ast (ast:arg1-ast ast) global-environment lexical-environment)
       ,(translate-ast (ast:arg2-ast ast) global-environment lexical-environment)))
