class DiceModel {

    constructor() {
        this.resultados = [];
        this.frecuencias = [0, 0, 0, 0, 0, 0];
    }

    lanzar() {

        let numero = Math.floor(Math.random() * 6) + 1;

        this.resultados.push(numero);

        this.frecuencias[numero - 1]++;

        return numero;
    }

    reiniciar() {

        this.resultados = [];
        this.frecuencias = [0, 0, 0, 0, 0, 0];
    }
}