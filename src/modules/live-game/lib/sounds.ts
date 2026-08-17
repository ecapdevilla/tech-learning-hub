export type GameSound =
  | "join"
  | "start"
  | "tick"
  | "correct"
  | "wrong"
  | "reveal"
  | "winner";

function tone(
  frequency: number,
  duration = 0.12,
  type: OscillatorType = "sine",
  gain = 0.06,
) {
  if (typeof window === "undefined") return;
  const AudioCtx =
    window.AudioContext ||
    (window as typeof window & { webkitAudioContext?: typeof AudioContext })
      .webkitAudioContext;

  if (!AudioCtx) return;
  const ctx = new AudioCtx();
  const osc = ctx.createOscillator();
  const vol = ctx.createGain();

  osc.type = type;
  osc.frequency.value = frequency;
  vol.gain.value = gain;

  osc.connect(vol);
  vol.connect(ctx.destination);

  osc.start();
  vol.gain.exponentialRampToValueAtTime(0.0001, ctx.currentTime + duration);
  osc.stop(ctx.currentTime + duration);
}

export function playGameSound(sound: GameSound) {
  switch (sound) {
    case "join":
      tone(520, 0.08);
      setTimeout(() => tone(660, 0.1), 70);
      break;
    case "start":
      tone(392, 0.12);
      setTimeout(() => tone(523, 0.12), 110);
      setTimeout(() => tone(659, 0.2), 220);
      break;
    case "tick":
      tone(820, 0.05, "square", 0.025);
      break;
    case "correct":
      tone(523, 0.1);
      setTimeout(() => tone(659, 0.1), 90);
      setTimeout(() => tone(784, 0.18), 180);
      break;
    case "wrong":
      tone(220, 0.14, "sawtooth", 0.035);
      setTimeout(() => tone(165, 0.2, "sawtooth", 0.03), 120);
      break;
    case "reveal":
      tone(440, 0.08);
      setTimeout(() => tone(554, 0.08), 80);
      break;
    case "winner":
      [523, 659, 784, 1046].forEach((f, i) =>
        setTimeout(() => tone(f, 0.2), i * 120),
      );
      break;
  }
}
