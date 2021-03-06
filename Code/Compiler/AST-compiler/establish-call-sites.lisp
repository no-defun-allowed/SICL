(cl:in-package #:sicl-compiler)

(defun establish-call-site (instruction code-object)
  (typecase instruction
    (cleavir-ir:named-call-instruction
     (change-class instruction
                   'sicl-ir:named-call-instruction
                   :function-cell-cell (list nil))
     (push (make-instance 'call-site
             :name (cleavir-ir:callee-name instruction)
             :instruction instruction)
           (call-sites code-object)))
    (cleavir-ir:catch-instruction
     (push (make-instance 'call-site
             :name 'sicl-run-time:augment-with-block/tagbody-entry
             :instruction instruction)
           (call-sites code-object)))
    (cleavir-ir:bind-instruction
     (push (make-instance 'call-site
             :name 'sicl-run-time:augment-with-special-variable-entry
             :instruction instruction)
           (call-sites code-object)))
    (cleavir-ir:unwind-instruction
     (push (make-instance 'call-site
             :name 'sicl-run-time:unwind
             :instruction instruction)
           (call-sites code-object)))
    (cleavir-ir:initialize-values-instruction
     (push (make-instance 'call-site
             ;; FIXME: Call a better function.
             :name 'error
             :instruction instruction)
           (call-sites code-object)))
    (cleavir-ir:multiple-value-call-instruction
     (push (make-instance 'call-site
             :name 'sicl-run-time:call-with-values
             :instruction instruction)
           (call-sites code-object)))))

(defun establish-call-sites (code-object)
  (cleavir-ir:map-instructions-arbitrary-order
   (lambda (instruction)
     (establish-call-site instruction code-object))
   (ir code-object)))
