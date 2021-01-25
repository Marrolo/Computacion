(deffunction fuzzify (?fztemplate ?value ?delta)
	(bind ?low (get-u-from ?fztemplate))
	(bind ?hi (get-u-to ?fztemplate))

	(if (<= ?value ?low)
	  then
	    (assert-string
	      (format nil "(%s (%g 1.0) (%g 0.0))" ?fztemplate ?low ?delta))
	else
	  (if (>= ?value ?hi)
	    then
	      (assert-string
	        (format nil "(%s (%g 0.0) (%g 1.0))"
			?fztemplate (- ?hi ?delta) ?hi))
	    else
	      (assert-string
		 (format nil "(%s (%g 0.0) (%g 1.0) (%g 0.0))"
			?fztemplate (max ?low (- ?value ?delta))
			?value (min ?hi (+ ?value ?delta)) ))
		))) 



(deftemplate casa
	(slot categoria (type INTEGER))
	(slot edadAparente (type INTEGER))
	(slot valorCatastral (type INTEGER))
	(slot vueMax (type FLOAT)) 
	(slot vueMoment (type FLOAT)) 
	(slot numVentanas (type INTEGER))) 


(deftemplate categoria ;Variable difusa
	0 150 puntos ;Universo
	( (economica (40 1) (70 0)) ;Valores difusos
	(estandar (40 0) (70 1) (100 0))
	(intermedia (70 0) (100 1) (130 0))
	(alta (100 0) (130 1)))) 

(deftemplate edadAparente ;Variable difusa
	0 100 anyos ;Universo
	( (reciente (0 1) (12 0)) ;Valores difusos
	(nuevo (0 0) (12 1) (24 0))
	(medio (25 0) (36 1) (48 0))
	(viejo (48 0) (60 1)))) 

(deftemplate valorCatastral ;Variable difusa
	0 100000 e/m2 ;Universo
	( (bajisimo (500 1) (1500 0)) ;Valores difusos
	(bajo (500 0) (1500 1) (2500 0))
	(medio (2500 0) (3500 1) (4500 0))
	(alto (4500 0) (5500 1) (6500 0))
	(altisimo (5500 0) (6500 1)))) 


(defrule r1
	(categoria alta)
	(edadAparente reciente)
	=>
	(assert (valorCatastral altisimo)))

(defrule r2
	(categoria alta)
	(edadAparente not [ medio or viejo ] )
	=>
	(assert (valorCatastral alto)))

(defrule r3
	(categoria alta)
	(edadAparente not [ reciente or nuevo ] )
	=>
	(assert (valorCatastral medio)))

(defrule r4
	(categoria intermedia)
	(edadAparente nuevo)
	=>
	(assert (valorCatastral not [ medio or alto ] )))

(defrule r5
	(categoria intermedia)
	(edadAparente not [ medio or viejo ] )
	=>
	(assert (valorCatastral bajo)))

(defrule r6
	(categoria estandar)
	(edadAparente nuevo)
	=>
	(assert (valorCatastral medio)))

(defrule r7
	(categoria estandar)
	(edadAparente viejo)
	=>
	(assert (valorCatastral bajisimo)))

(defrule r8
	(categoria economica)
	(edadAparente nuevo)
	=>
	(assert (valorCatastral not [ bajo or medio ] )))

(defrule r9
	(categoria economica)
	(edadAparente not [ reciente or nuevo ] )
	=>
	(assert (valorCatastral bajisimo)))

(defrule leerconsolaEdad ;lee de consola un valor crisp y aserta su valor fusificado
	(initial-fact)
	=>
	(printout t "Introduzca la edad en anyos" crlf)
	(bind ?Redad (read))
	(fuzzify edadAparente ?Redad 0.1)

	(printout t "Introduzca la categoria en puntos" crlf)
	(bind ?Rcat (read))
	(fuzzify categoria ?Rcat 0.1)

	(printout t "Introduzca numero ventanas" crlf)
	(bind ?Rvent (read))
	(assert (numVentanas ?Rvent))

)

(defrule ventanas
	(numVentanas ?vent)
	(test(< ?vent 3))
	=>
	 (assert(valorCatastral more-or-less bajo))


)

(defrule ventanas2
	(numVentanas ?vent)
	(test(> ?vent 5))
	=>
	 (assert (valorCatastral very alto)) 


)

(defrule defuzzificar ; Regla final para determinar valor exacto de vue
    (declare (salience -1)) ; mínima prioridad (última regla)
    (valorCatastral ?val)
    =>
    (assert (crisp vueMax (maximum-defuzzify ?val)))
    (assert (crisp vueMoment (moment-defuzzify ?val)))
    (printout t "Edad por moment: " (moment-defuzzify ?val) crlf)
    (printout t "Edad por maximum: " (maximum-defuzzify ?val) crlf)
)

;(defrule leerconsola ;lee de consola un valor difuso y lo aserta
; (initial-fact)
;=>
; (printout t "Introduzca la edad de la casa: reciente, nuevo, medio, viejo" crlf)
; (bind ?Redad (read))
; (assert-string (format nil "(edadAparente %s)" ?Redad)) 
; )