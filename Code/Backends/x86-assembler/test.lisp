(in-package :x86-assembler)

;;; Test instructions with an opcode of #x83 and where the
;;; first operand is a 32-bit GPR between 1 and 7.
(defun run-test-83-reg-1 (mnemonic extension reg imm)
  (let ((x (make-instance 'code-command
	     :mnemonic mnemonic
	     :operands (list
			(make-instance 'gpr-operand
			  :code-number reg
			  :size 32)
			(make-instance 'immediate-operand
			  :value imm))))
	(y `(#x83
	     ,(+ #xC0 (ash extension 3) reg)
	     ,(if (minusp imm) (+ imm 256) imm))))
    (assert (equal (list y) (assemble (list x))))))

;;; Test instructions with an opcode of #x83 and where the
;;; first operand is a 32-bit GPR between 8 and 15.
(defun run-test-83-reg-2 (mnemonic extension reg imm)
  (let ((x (make-instance 'code-command
	     :mnemonic mnemonic
	     :operands (list
			(make-instance 'gpr-operand
			  :code-number reg
			  :size 32)
			(make-instance 'immediate-operand
			  :value imm))))
	(y `(#x41 ; Rex prefix
	     #x83
	     ,(+ #xC0 (ash extension 3) (- reg 8))
	     ,(if (minusp imm) (+ imm 256) imm))))
    (assert (equal (list y) (assemble (list x))))))

(defun run-test-1 ()
  (loop for mnemonic in '("ADD" "OR" "AND" "XOR")
	for extension in '(0 1 4 6)
	do (loop for reg from 1 to 7
		 do (loop for imm from -128 to 127
			  do (run-test-83-reg-1 mnemonic extension reg imm)))
	   (loop for reg from 8 to 15
		 do (loop for imm from -128 to 127
			  do (run-test-83-reg-2 mnemonic extension reg imm)))))

(defun run-tests ()
  (run-test-1))
