
	Algoritmo SimuladorDados
		
		Definir cantidad, i, j, dado Como Entero
		Definir resultados Como Entero
		Definir frecuencias Como Entero
		
		Dimension resultados[100]
		Dimension frecuencias[6]
		
		Escribir "SIMULADOR DE DADOS"
		Escribir "Ingrese la cantidad de lanzamientos:"
		Leer cantidad
		
		Mientras cantidad < 1 O cantidad > 100 Hacer
			Escribir "Ingrese un numero entre 1 y 100:"
			Leer cantidad
		FinMientras
		
		Para i <- 1 Hasta 6 Hacer
			frecuencias[i] <- 0
		FinPara
		
		Para i <- 1 Hasta cantidad Hacer
			dado <- Aleatorio(1,6)
			resultados[i] <- dado
			frecuencias[dado] <- frecuencias[dado] + 1
			Escribir "Lanzamiento ", i, ": ", dado
		FinPara
		
		Escribir ""
		Escribir "HISTOGRAMA"
		
		Para i <- 1 Hasta 6 Hacer
			Escribir Sin Saltar i, ": "
			
			Para j <- 1 Hasta frecuencias[i] Hacer
				Escribir Sin Saltar "*"
			FinPara
			
			Escribir " (", frecuencias[i], ")"
		FinPara
		
		Escribir "Simulacion terminada."
		
FinAlgoritmo
