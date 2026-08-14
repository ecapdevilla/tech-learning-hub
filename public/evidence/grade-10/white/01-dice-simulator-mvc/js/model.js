const DiceModel = {
  rolls: [],
  rollDice() {
    const value = Math.floor(Math.random() * 6) + 1;
    this.rolls.push(value);
    return value;
  },
  reset() {
    this.rolls = [];
  },
};
