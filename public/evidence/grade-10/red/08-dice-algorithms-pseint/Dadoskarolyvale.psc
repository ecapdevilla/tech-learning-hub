
	Algoritmo SimuladorDados
		
		Definir cantidad, i, dado Como Entero
		
		Escribir "SIMULADOR DE DADOS"
		Escribir "Cuantos lanzamientos desea realizar?"
		Leer cantidad
		
		Para i <- 1 Hasta cantidad Hacer
			dado <- Aleatorio(1, 6)
			Escribir "Lanzamiento ", i, ": ", dado
		FinPara
		
		Escribir "Simulacion terminada."

FinAlgoritmo
