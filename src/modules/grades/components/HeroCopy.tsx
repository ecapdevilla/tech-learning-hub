type Props = {
  eyebrow: string;
  title: string;
  description: string;
};

export function HeroCopy({ eyebrow, title, description }: Props) {
  return (
    <div>
      <span className="eyebrow">{eyebrow}</span>
      <h1>
        Learn.
        <br />
        Practice.
        <br />
        <span>{title}</span>
      </h1>
      <p className="hero-copy">{description}</p>
    </div>
  );
}