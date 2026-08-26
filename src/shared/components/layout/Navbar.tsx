import Link from "next/link";
import { LanguageSwitcher } from "@/shared/components/ui/LanguageSwitcher";

export function Navbar() {
  return (
    <header className="site-header">
      <div className="page-shell nav-inner">
        <Link href="/" className="brand">
          <span className="brand-mark">⚡</span>
          <span>Tech Learning Hub</span>
        </Link>

        <nav className="nav-links">
          <Link href="/math">Math</Link>
          <Link href="/explore">Explore</Link>
          <Link href="/resources">Resources</Link>
          <LanguageSwitcher />
        </nav>
      </div>
    </header>
  );
}