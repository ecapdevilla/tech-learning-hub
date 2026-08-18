import {
  playGameSound,
  type GameSound,
} from "@/modules/live-game/lib/sounds";

/**
 * Audio must never be allowed to crash a classroom game.
 * Some mobile browsers block or partially implement WebAudio depending on
 * user gesture, power mode, browser engine or media policy.
 */
export function safePlayGameSound(sound: GameSound) {
  try {
    playGameSound(sound);
  } catch {
    // Sound feedback is optional. Game state and connectivity always win.
  }
}
