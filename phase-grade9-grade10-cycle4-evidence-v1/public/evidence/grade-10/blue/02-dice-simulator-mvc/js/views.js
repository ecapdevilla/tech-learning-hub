const DiceView = {
  showDice(value) {
    document.getElementById("dice").textContent = value;
  },

  showHistory(rolls) {
    document.getElementById("history").textContent =
      "[" + rolls.join(", ") + "]";
  }
};
