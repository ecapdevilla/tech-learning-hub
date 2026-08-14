function rollOnce() {
    const value = DiceModel.rollDice();

    DiceView.showDice(value);
    DiceView.showHistory(DiceModel.rolls);

    updateHistogram();
}

document.getElementById("rollBtn").addEventListener("click", rollOnce);

document.getElementById("roll10Btn").addEventListener("click", () => {
    for (let i = 0; i < 10; i++) {
        rollOnce();
    }
});

document.getElementById("resetBtn").addEventListener("click", () => {
    DiceModel.reset();

    DiceView.showDice("🎲");
    DiceView.showHistory([]);

    updateHistogram();
});

function generateTable(number) {
    const results = [];

    for (let i = 1; i <= 10; i++) {
        results.push(
            number + " × " + i + " = " + (number * i)
        );
    }

    return results;
}

document.getElementById("generateBtn").addEventListener("click", () => {
    const number = Number(
        document.getElementById("numberInput").value
    );

    const results = generateTable(number);

    DiceView.showTable(results);
});

function updateHistogram() {
    const counts = [0, 0, 0, 0, 0, 0];

    for (let i = 0; i < DiceModel.rolls.length; i++) {
        const value = DiceModel.rolls[i];

        counts[value - 1]++;
    }

    DiceView.showHistogram(counts);
}