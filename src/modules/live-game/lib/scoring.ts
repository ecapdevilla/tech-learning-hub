export function calculatePoints(
  correct: boolean,
  responseMs: number,
  questionSeconds: number,
  streak: number,
) {
  if (!correct) return 0;

  const maxMs = questionSeconds * 1000;
  const speedRatio = Math.max(0, Math.min(1, 1 - responseMs / maxMs));
  const base = 700;
  const speedBonus = Math.round(speedRatio * 300);
  const streakBonus = Math.min(streak, 5) * 50;

  return base + speedBonus + streakBonus;
}
