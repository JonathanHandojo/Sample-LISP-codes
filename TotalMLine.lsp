;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                                              ;;;
;;;                                        TotalMultiline                                        ;;;
;;;                                 Created by Jonathan Handojo                                  ;;;
;;;                                                                                              ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                                              ;;;
;;;  This LISP routine allows the user to summarise the total lengths of multilines depending    ;;;
;;;  on its multiline scale. The user invokes the command TML on the command line, and then      ;;;
;;;  selects a group of multilines to be calculated. The totals will then be segregated based    ;;;
;;;  on multiline scale.                                                                         ;;;
;;;                                                                                              ;;;
;;;  How to use the TML command:                                                                 ;;;
;;;                                                                                              ;;;
;;;  1. Select a group of multilines you wish to calculate its lengths                           ;;;
;;;  2. Specify a point somewhere and an mtext with the details will be shown.                   ;;;
;;;                                                                                              ;;;
;;;                 ------------------------------------------------------------                 ;;;
;;;                                            Notes:                                            ;;;
;;;                 ------------------------------------------------------------                 ;;;
;;;                                                                                              ;;;
;;;  This program segregates multiline scales that are unique up to one decimal place. This      ;;;
;;;  means that if you have two multilines of scales 10.02 and 10.04 as an example, they will    ;;;
;;;  be considered equal and the details will then emerge as 10.0 with their combined lengths.   ;;;
;;;                                                                                              ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:tml (/ *error* acadobj activeundo adoc asc cords getcords dets ms msp pt pts ss)
    (defun *error* ( msg )
	(vla-EndUndoMark adoc)
	(if (not (wcmatch (strcase msg T) "*break*,*cancel*,*exit*"))
	    (princ (strcat "Error: " msg))
	    )
	)
    
    (defun getcords (vml / cords pts)
	(setq pts (append '(nil nil nil) (vlax-get x 'Coordinates)))
	(while
	    (setq pts (cdddr pts))
	    (setq cords (cons (list (car pts) (cadr pts) (caddr pts)) cords))
	    )
	cords
	)
    
    (setq acadobj (vlax-get-acad-object)
	  adoc (vla-get-ActiveDocument acadobj)
	  msp (vla-get-ModelSpace adoc)
	  activeundo nil)
    (if (= 0 (logand 8 (getvar "UNDOCTL"))) (vla-StartUndoMark adoc) (setq activeundo T))

    (if
	(and
	    (setq ss (ssget '((0 . "MLINE"))))
	    (setq pt (getpoint "\nSpecify insertion point: "))
	    )
	(progn
	    (foreach x (JH:selset-to-list-vla ss)
		(setq cords (getcords x))
		(if (setq ms (rtos (abs (vla-get-MLineScale x)) 2 1) asc (assoc ms dets))
		    (setq dets (subst (cons ms (apply '+ (append (list (cdr asc)) (mapcar 'distance cords (cdr cords))))) asc dets))
		    (setq dets (cons (cons ms (apply '+ (mapcar 'distance cords (cdr cords)))) dets))
		    )
		)
	    (entmake
		(list
		    '(0 . "MTEXT")
		    '(100 . "AcDbEntity")
		    '(100 . "AcDbMText")
		    (cons 10 pt)
		    (cons 40 (* (/ (getvar 'viewsize) (cadr (getvar 'screensize))) 20))
		    (cons 1
			  (strcat
			      "Multiline Details"
			      "\n"
			      "\nSize : Length"
			      "\n"
			      "\n"
			      (JH:lst->str
				  (mapcar
				      '(lambda (x)
					   (strcat (car x) " : " (rtos (cdr x) 2 2))
					   )
				      dets
				      )
				  "\n"
				  )
			      "\n"
			      "\nOverall Total: " (rtos (apply '+ (mapcar 'cdr dets)) 2 2)
			      )
			  )
		    (cons 7 (getvar 'textstyle))
		    '(50 . 0.0)
		    )
		)
	    )
	)
    (if activeundo nil (vla-EndUndoMark adoc))
    (princ)
    )

;; JH:selset-to-list-vla --> Jonathan Handojo
;; Returns a list of vla objects from a selection set
;; ss - selection set

(defun JH:selset-to-list-vla (ss / rtn i)
    (if ss
	(repeat (setq i (sslength ss))
	    (setq rtn (cons (vlax-ename->vla-object (ssname ss (setq i (1- i)))) rtn))
	    )
	)
    )

;; JH:lst->str --> Jonathan Handojo
;; Concatenates a list of string into one string with a specified delimeter
;; lst - list of strings
;; del - delimiter string

(defun JH:lst->str (lst del)
    (apply 'strcat (append (list (car lst)) (mapcar '(lambda (x) (strcat del x)) (cdr lst))))
    )

(vl-load-com)