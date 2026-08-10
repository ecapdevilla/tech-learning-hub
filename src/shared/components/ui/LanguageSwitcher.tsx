"use client";

import { useState } from "react";

export function LanguageSwitcher() {
  const [lang, setLang] = useState<"en" | "es">("en");

  function changeLanguage(value: "en" | "es") {
    setLang(value);
    document.documentElement.lang = value;
    document.body.dataset.lang = value;
  }

  return (
    <div className="flex gap-2">
      <button
        onClick={() => changeLanguage("en")}
        className={lang === "en" ? "lang-active" : "lang-button"}
      >
        🇺🇸 EN
      </button>
      <button
        onClick={() => changeLanguage("es")}
        className={lang === "es" ? "lang-active" : "lang-button"}
      >
        🇨🇴 ES
      </button>
    </div>
  );
}