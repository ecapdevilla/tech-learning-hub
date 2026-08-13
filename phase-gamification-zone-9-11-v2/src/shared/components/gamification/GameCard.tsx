import type { GameArena } from "@/modules/gamification/types/game";

export function GameCard({ game }: { game: GameArena }) {
  return (
    <a className="game-card" href={game.href}>
      <span className="game-level">{game.grades}</span>
      <span className="game-icon">{game.icon}</span>
      <small>{game.domain}</small>
      <h3>{game.title}</h3>
      <p>{game.subtitle}</p>
      <p className="game-objective"><b>Objective:</b> {game.objective}</p>
      <span className="difficulty">{game.difficulty}</span>
      <b className="play-link">PLAY / JUGAR / JOUER →</b>
    </a>
  );
}
