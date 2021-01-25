#!/usr/bin/gnuplot -persist

# Tipo de fichero que se genera seguido de las opciones específicas de
# ese tipo de fichero. Os dejo como ejemplo la generación de un fichero
# de tipo eps "encapsulated postscript" que es un formato vectorial que
# garantiza un escalado arbitráreo de las gráficas sin efectos de pixelado

set terminal postscript eps color font "Helvetica,24"

# Otro tipo de fichero que puede generar gnuplot es JPEG, que es un
# tipo ampliamente conocido de mapa de bits (no vectorial), pero que
# no puede ser escalado arbitráreamente. Se puede generar con el comando:
# set terminal jpeg

#
# Nombre del fichero de salida
#

set output "mixGaussian.eps"

# Establece que los ejes estén en escala logarítmica
# para observar más fácilmente valores muy cercanos entre si

set logscale xy

#
# Rangos del eje x y del eje y
#

set xrange [0.9:101]
set yrange [1.0:100]

# Define los puntos de referencia (tics) sobre el eje x y el eje y
# Entre paréntesis se indican separados por coma la etiqueta de texto
# entre comillas dobles y la posición en ese eje donde aparece la
# etiqueta

set xtics ("1" 1, "2" 2, "5" 5, "10" 10, "20" 20, "50" 50, "100" 100)
set ytics ("1" 1, "2" 2, "5" 5, "10" 10, "20" 20, "50" 50, "100" 100)

# Definimos el texto que usamos para poner etiquetas en la gráfica:
# - El eje x "Dimensionalidad"
# - El eje y "Error (%)"
# - La línea horizontal que representa la tasa de error sin aplicar PCA "Original"
# - El título de la gráfica "MNIST 1-NN"
#
# Después del texto que se muestra en la gráfica aparecen las coordenadas (at x,y)
# donde debe aparecer la etiqueta seguido de como se alinea el texto (right, left, center)
# e incluso el tipo y tamaño de la fuente: font  "HelveticaBold,30"

set label "Numero mixturas" at 100,1.5 right
set label "Error (%)" at 0.92,85 left
set label "Mixturas alpha = 1e-3" at 0.92,50 left font "HelveticaBold,20"


# El comando plot representa las dos curvas que aparecen en la
# gráfica. La primera curva es la de PCA y la segunda, la Original,
# es decir, sin aplicar PCA.
#
# En ese comando plot la especificación de cada una de las curvas está
# separada por coma de la otra
# Primera: "pca+knn-exp.out" u 1:2 t "PCA" w lp lw 2 lt 1 ps 2.0
# Segunda: 2.82 not w l lw 4 lt 2
#
# Sobre la primera curva, el fichero pca+knn-exp.out es un fichero de
# texto con dos columnas. La primera columna es el número de
# dimensiones a los cuales proyectas y la segunda columna es la tasa
# de error del clasificador de 1 vecino más cercano cuando utilizas
# ese número de dimensiones.
#
# El comando plot para la primera curva se interpreta de la siguiente
# manera: el fichero pca+knn-exp.out se representa gráficamente
# mediante una curva usando (u) la columna 1 como eje x y la columna 2
# como eje y siendo el título de la curva "PCA", el tipo de curva es
# de una línea con los puntos experimentales sobre la misma
# "with linespoints" (w lp), el "linewidth" de la curva es 2 (lw 2), el "linetype"
# es la 1 (lt 1) y el "pointsize" es 2.0 (ps 2.0)
#
# El plot para la segunda curva es una línea horizontal cuyo valor
# constante es 2.82 para todo valor de x, no quiero título "notitle" (not) para esta curva,
# el tipo de curva es una línea "with line" (w l) cuyo linewidth es 4 (lw 4)
# y el tipo de línea es la 2 (lt 2)

plot "3/10.out" u 3:4 t "PCA: 10 dimension" w lp lw 2 lt rgb "red" ps 2.0, "3/20.out" u 3:4 t "PCA: 20 dimension" w lp lw 2 lt rgb "green" ps 2.0,  "3/50.out" u 3:4 t "PCA: 50 dimension" w lp lw 2 lt rgb "blue" ps 2.0,  "3/100.out" u 3:4 t "PCA: 100 dimension" w lp lw 2 lt rgb "black" ps 2.0
# Si quieres saber más sobre los anchos de línea, tipos de línea/punto, etc. ejecuta
# "gnuplot" desde el interprete de comandos, y dentro de gnuplot ejecuta el comando "test"
#"5/1.out" u 3:4 t "PCA: 1 dimension" w lp lw 2 lt 1 ps 2.0,
#"5/2.out" u 3:4 t "PCA: 2 dimension" w lp lw 2 lt 1 ps 2.0,  "5/5.out" u 3:4 t "PCA: 5 dimension" w lp lw 2 lt 1 ps 2.0,