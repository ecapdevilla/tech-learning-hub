import Link from "next/link";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";
import { gameArenas } from "@/modules/gamification/data/games";
import { GamificationHero } from "@/shared/components/gamification/GamificationHero";
import { GamificationIntro } from "@/shared/components/gamification/GamificationIntro";
import { GameCard } from "@/shared/components/gamification/GameCard";
import { TechPassport } from "@/shared/components/gamification/TechPassport";
import { FrenchPassport } from "@/shared/components/gamification/FrenchPassport";

export default function GamificationPage() {
  return (
    <SiteLayout>
      <main className="gamification-zone page-shell">
        <Link href="/" className="back-link">← Back to Tech Learning Hub</Link>
        <GamificationHero />
        <GamificationIntro />
        <TechPassport />
        <section className="game-grid">
          {gameArenas.map((game) => <GameCard key={game.id} game={game} />)}
        </section>
        <FrenchPassport />
      </main>
    </SiteLayout>
  );
}
