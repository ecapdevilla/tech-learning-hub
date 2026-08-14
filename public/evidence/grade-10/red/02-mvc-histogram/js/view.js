class DiceView {

    mostrarResultado(numero) {

        document.getElementById("resultado").textContent =
            "Salió el número: " + numero;

        document.getElementById("dado").textContent = "🎲 " + numero;
    }

    mostrarHistograma(frecuencias) {

        let histograma = document.getElementById("histograma");

        histograma.innerHTML = "";

        let maximo = Math.max(...frecuencias, 1);

        for (let i = 0; i < 6; i++) {

            let barra = document.createElement("div");

            barra.className = "barra";

            let altura = (frecuencias[i] / maximo) * 200;

            barra.style.height = altura + "px";

            barra.textContent = frecuencias[i];

            histograma.appendChild(barra);
        }
    }

    reiniciar() {

        document.getElementById("resultado").textContent =
            "Presiona 'Lanzar Dado'";

        document.getElementById("dado").textContent = "🎲";

        document.getElementById("histograma").innerHTML = "";
    }
}