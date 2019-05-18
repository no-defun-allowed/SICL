(cl:in-package #:sicl-hir-to-cl-test)

(defun make-environment ()
  (let ((environment
          (make-instance 'sicl-alternative-extrinsic-environment:environment)))
    (sicl-alternative-extrinsic-environment::import-from-host environment)
    (sicl-hir-to-cl::fill-environment environment)
    environment))

(defun test-let (client)
  (let ((environment (make-environment))
        (form '(let ((x 10)) (+ x 20))))
    (setf (sicl-genv:fdefinition '+ environment) #'+)
    (assert (eql (eval client form environment) 30))))

(defun test-symbol-value (client)
  (let ((environment (make-environment))
        (form '(+ *x* 20)))
    (setf (sicl-genv:fdefinition '+ environment) #'+)
    (setf (sicl-genv:special-variable '*x* environment t) 10)
    (assert (eql (eval client form environment) 30))))

(defun test-block-1 (client)
  (let ((environment (make-environment))
        (form '(let ((x 10))
                (block hello
                  (return-from hello (+ x 20))
                  50))))
    (setf (sicl-genv:fdefinition '+ environment) #'+)
    (assert (eql (eval client form environment) 30))))

(defun test-block-2 (client)
  (let ((environment (make-environment))
        (form '(let ((x 10))
                (block hello
                  (let ((y 20))
                    (return-from hello (+ x y)))
                  50))))
    (setf (sicl-genv:fdefinition '+ environment) #'+)
    (assert (eql (eval client form environment) 30))))

(defun test-block (client)
  (test-block-1 client)
  (test-block-2 client))

(defun test-bind (client)
  (let ((environment (make-environment))
        (form '(flet ((stuff (x) (+ x *x*)))
                (let ((*x* 10))
                  (stuff 20)))))
    (setf (sicl-genv:fdefinition '+ environment) #'+)
    (setf (sicl-genv:special-variable '*x* environment t) 5)
    (assert (eql (eval client form environment) 30))))

(defun test-car (client)
  (let ((environment (make-environment))
        (form '(cleavir-primop:car (list 1 2))))
    (setf (sicl-genv:fdefinition 'list environment) #'list)
    (setf (sicl-genv:special-operator 'cleavir-primop:car environment) t)
    (assert (eql (eval client form environment) 1))))

(defun test-cdr (client)
  (let ((environment (make-environment))
        (form '(cleavir-primop:cdr (list 1 2))))
    (setf (sicl-genv:fdefinition 'list environment) #'list)
    (setf (sicl-genv:special-operator 'cleavir-primop:cdr environment) t)
    (assert (equal (eval client form environment) '(2)))))

(defun test-rplaca (client)
  (let ((environment (make-environment))
        (form '(let ((l (list 1))) (cleavir-primop:rplaca l 2) l)))
    (setf (sicl-genv:fdefinition 'list environment) #'list)
    (setf (sicl-genv:special-operator 'cleavir-primop:rplaca environment) t)
    (assert (equal (eval client form environment) '(2)))))

(defun test-rplacd (client)
  (let ((environment (make-environment))
        (form '(let ((l (cons 2 3))) (cleavir-primop:rplacd l 1) l)))
    (setf (sicl-genv:fdefinition 'list environment) #'list)
    (setf (sicl-genv:special-operator 'cleavir-primop:rplacd environment) t)
    (assert (equal (eval client form environment) '(2 . 1)))))

(defun test-eq (client)
  (let ((environment (make-environment))
        (form '(if (null (list)) 1 2)))
    (setf (sicl-genv:fdefinition 'list environment) #'list)
    (setf (sicl-genv:fdefinition 'null environment) #'null)
    (assert (eql (eval client form environment) 1))))

(defun test (client)
  (test-let client)
  (test-symbol-value client)
  (test-block client)
  (test-bind client)
  (test-car client)
  (test-cdr client)
  (test-rplaca client)
  (test-rplacd client)
  (test-eq client))
