const DiceView = {

    showDice(value) {
        document.getElementById("dice").textContent = value;
    },

    showHistory(rolls) {
        document.getElementById("history").textContent =
            "[" + rolls.join(", ") + "]";
    },

    showTable(results) {
        document.getElementById("tableResult").innerHTML =
            results.join("<br>");
    },

    showHistogram(counts) {
        const histogram = document.getElementById("histogram");

        histogram.innerHTML = "";

        for (let i = 0; i < counts.length; i++) {

            const row = document.createElement("div");

            row.innerHTML =
                "<strong>" + (i + 1) + ":</strong> " +
                "█".repeat(counts[i]) +
                " (" + counts[i] + ")";

            histogram.appendChild(row);
        }
    }
};