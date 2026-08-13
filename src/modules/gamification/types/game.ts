export type GameArena = {
  id: string;
  title: string;
  subtitle: string;
  icon: string;
  grades: string;
  domain: string;
  objective: string;
  href: string;
  difficulty: "Explorer" | "Builder" | "Master";
};
