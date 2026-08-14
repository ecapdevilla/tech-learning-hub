const model = new DiceModel();
const view = new DiceView();

document.getElementById("lanzar").addEventListener("click", function() {

    let numero = model.lanzar();

    view.mostrarResultado(numero);

    view.mostrarHistograma(model.frecuencias);

});

document.getElementById("reiniciar").addEventListener("click", function() {

    model.reiniciar();

    view.reiniciar();

});