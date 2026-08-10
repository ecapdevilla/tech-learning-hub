import { SiteLayout } from "@/shared/components/layout/SiteLayout";

export default function ExplorePage() {
  return (
    <SiteLayout>
      <section className="page-shell simple-page">
        <span className="section-kicker">Explore</span>
        <h1>Explore all learning resources</h1>
        <p>
          Search and cross-grade discovery will be enabled in the next phase.
        </p>
      </section>
    </SiteLayout>
  );
}