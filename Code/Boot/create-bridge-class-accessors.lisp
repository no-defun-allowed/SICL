(cl:in-package #:sicl-boot)

(defun create-bridge-class-accessors (boot)
  (let ((c (c2 boot))
	(r (r3 boot)))
    ;; Accessors for generic function metaobjects.
    (ld "../CLOS/generic-function-name-defgeneric.lisp" c r)
    (ld "../CLOS/generic-function-lambda-list-defgeneric.lisp" c r)
    (ld "../CLOS/generic-function-argument-precedence-order-defgeneric.lisp" c r)
    (ld "../CLOS/generic-function-declarations-defgeneric.lisp" c r)
    (ld "../CLOS/generic-function-method-class-defgeneric.lisp" c r)
    (ld "../CLOS/generic-function-method-combination-defgeneric.lisp" c r)
    (ld "../CLOS/generic-function-methods-defgeneric.lisp" c r)
    (ld "../CLOS/setf-generic-function-methods-defgeneric.lisp" c r)
    (ld "../CLOS/call-history-defgeneric.lisp" c r)
    (ld "../CLOS/setf-call-history-defgeneric.lisp" c r)
    (ld "../CLOS/specializer-profile-defgeneric.lisp" c r)
    (ld "../CLOS/setf-specializer-profile-defgeneric.lisp" c r)
    ;; Accessors for method metaobjects.
    (ld "../CLOS/method-function-defgeneric.lisp" c r)
    (ld "../CLOS/method-generic-function-defgeneric.lisp" c r)
    (ld "../CLOS/setf-method-generic-function-defgeneric.lisp" c r)
    (ld "../CLOS/method-lambda-list-defgeneric.lisp" c r)
    (ld "../CLOS/method-qualifiers-defgeneric.lisp" c r)
    (ld "../CLOS/method-specializers-defgeneric.lisp" c r)
    (ld "../CLOS/accessor-method-slot-definition-defgeneric.lisp" c r)
    ;; Accessors for slot definition metaobjects.
    (ld "../CLOS/slot-definition-name-defgeneric.lisp" c r)
    (ld "../CLOS/slot-definition-allocation-defgeneric.lisp" c r)
    (ld "../CLOS/slot-definition-type-defgeneric.lisp" c r)
    (ld "../CLOS/slot-definition-initargs-defgeneric.lisp" c r)
    (ld "../CLOS/slot-definition-initform-defgeneric.lisp" c r)
    (ld "../CLOS/slot-definition-initfunction-defgeneric.lisp" c r)
    (ld "../CLOS/slot-definition-readers-defgeneric.lisp" c r)
    (ld "../CLOS/slot-definition-writers-defgeneric.lisp" c r)
    (ld "../CLOS/slot-definition-location-defgeneric.lisp" c r)
    ;; Accessors for specializer metaobjects.
    (ld "../CLOS/specializer-direct-generic-functions-defgeneric.lisp" c r)
    (ld "../CLOS/setf-specializer-direct-generic-functions-defgeneric.lisp" c r)
    (ld "../CLOS/specializer-direct-methods-defgeneric.lisp" c r)
    (ld "../CLOS/setf-specializer-direct-methods-defgeneric.lisp" c r)
    (ld "../CLOS/specializer-profile-defgeneric.lisp" c r)
    (ld "../CLOS/setf-specializer-profile-defgeneric.lisp" c r)
    (ld "../CLOS/unique-number-defgeneric.lisp" c r)
    (ld "../CLOS/class-name-defgeneric.lisp" c r)
    (ld "../CLOS/class-direct-superclasses-defgeneric.lisp" c r)
    (ld "../CLOS/class-direct-subclasses-defgeneric.lisp" c r)
    (ld "../CLOS/setf-class-direct-subclasses-defgeneric.lisp" c r)
    (ld "../CLOS/class-direct-slots-defgeneric.lisp" c r)
    (ld "../CLOS/class-direct-default-initargs-defgeneric.lisp" c r)
    (ld "../CLOS/class-precedence-list-defgeneric.lisp" c r)
    (ld "../CLOS/class-slots-defgeneric.lisp" c r)
    (ld "../CLOS/class-default-initargs-defgeneric.lisp" c r)
    (ld "../CLOS/class-finalized-p-defgeneric.lisp" c r)
    (ld "../CLOS/setf-class-finalized-p-defgeneric.lisp" c r)
    (ld "../CLOS/class-prototype-defgeneric.lisp" c r)
    ;; General accessors.
    (ld "../CLOS/dependents-defgeneric.lisp" c r)
    (ld "../CLOS/setf-dependents-defgeneric.lisp" c r)
    (ld "../CLOS/documentation-defgeneric.lisp" c r)
    (ld "../CLOS/setf-documentation-defgeneric.lisp" c r)))
