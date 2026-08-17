"use client";

import { FormEvent, useState } from "react";
import { useRouter } from "next/navigation";

export default function JoinLiveGame() {
  const [pin, setPin] = useState("");
  const router = useRouter();

  const submit = (e: FormEvent) => {
    e.preventDefault();
    const clean = pin.replace(/\D/g, "").slice(0, 6);
    if (clean.length === 6) router.push(`/gamification/live/play/${clean}`);
  };

  return (
    <main className="live-shell">
      <section className="live-join-card">
        <span className="live-kicker">STUDENT JOIN</span>
        <h1>Enter Game PIN</h1>
        <form onSubmit={submit}>
          <input
            className="live-pin-input"
            inputMode="numeric"
            pattern="[0-9]*"
            maxLength={6}
            placeholder="000000"
            value={pin}
            onChange={(e) => setPin(e.target.value.replace(/\D/g, ""))}
          />
          <button className="live-btn live-btn-primary">Join →</button>
        </form>
      </section>
    </main>
  );
}
