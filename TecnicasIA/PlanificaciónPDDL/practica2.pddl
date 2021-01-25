(define (domain practica2)
(:requirements :durative-actions :typing :fluents)
(:types persona ciudad)
(:predicates    (at ?p - persona ?c - ciudad)   
                (residente ?p - persona)
                (tiene-ticket ?p - persona)
                (conexion-bus ?c1 - ciudad ?c2 - ciudad)
                (conexion-metro ?c1 - ciudad ?c2 - ciudad)
                (conexion-tren ?c1 - ciudad ?c2 - ciudad)
)

(:functions     (distancia-ciudades ?c1 - ciudad ?c2 - ciudad)
                (velocidad-metro)
                (velocidad-tren)
                (velocidad-bus)
                (precio-bonometro)
                (precio-tren)
                (viajes-bono ?p - persona)
                (dinero-persona ?p - persona)
                (coste-total)
)


(:durative-action viajar-bus
 :parameters (?p - persona ?c1 ?c2 - ciudad)
 :duration (= ?duration (/ (distancia-ciudades ?c1 ?c2) (velocidad-bus)))
 :condition (and (at start (at ?p ?c1))
                (over all (residente ?p))
                (at start (conexion-bus ?c1 ?c2))
                )
 :effect  (and (at start (not (at ?p ?c1)))            
              (at end (at ?p ?c2)))
)

(:durative-action viajar-metro
 :parameters (?p - persona ?c1 ?c2 - ciudad)
 :duration (= ?duration (/ (distancia-ciudades ?c1 ?c2) (velocidad-metro)))
 :condition (and (at start (at ?p ?c1))
                (at start(> (viajes-bono) 0))
                (at start (conexion-metro ?c1 ?c2)))
 :effect  (and (at start (not (at ?p ?c1)))
              (at start(decrease (viajes-bono ?p) 1))
              (at end (at ?p ?c2)))
              
)


(:durative-action viajar-tren
 :parameters (?p - persona ?c1 ?c2 - ciudad)
 :duration (= ?duration (/ (distancia-ciudades ?c1 ?c2) (velocidad-tren)))
 :condition (and (at start (at ?p ?c1))
                (at start (conexion-tren ?c1 ?c2))
                (at start(tiene-ticket ?p)))
 :effect (and (at start (not (at ?p ?c1)))
              (at end (at ?p ?c2))
              (at start (not (tiene-ticket ?p))))              
)


(:durative-action recargar-bono
 :parameters (?p - persona)
 :duration (= ?duration 1)
 :condition (and(at start (>= (dinero-persona ?p) (precio-bonometro))))
 :effect (and (at end (increase (viajes-bono ?p) 10))
        (at start(decrease (dinero-persona ?p) (precio-bonometro)))
        (at start(increase (coste-total) (precio-bonometro))))
 
)


(:durative-action comprar-ticket-tren
 :parameters (?p - persona)
 :duration (= ?duration 2)
 :condition (and (at start (>= (dinero-persona ?p) (precio-tren))))
 :effect (and (at end (tiene-ticket ?p))
      (at start(decrease (dinero-persona ?p) (precio-tren)))
      (at start(increase (coste-total) (precio-tren))))

)

)
