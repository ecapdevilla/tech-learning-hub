"use client";

import { useRouter } from "next/navigation";
import Link from "next/link";
import { ArrowLeft, House } from "lucide-react";

export function PageNavigation() {
  const router = useRouter();

  return (
    <div className="page-navigation">
      <button onClick={() => router.back()} className="nav-action">
        <ArrowLeft size={17} />
        Back
      </button>

      <Link href="/" className="nav-action">
        <House size={17} />
        Home
      </Link>
    </div>
  );
}