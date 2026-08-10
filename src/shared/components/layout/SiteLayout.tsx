import { Navbar } from "@/shared/components/layout/Navbar";

type Props = {
  children: React.ReactNode;
};

export function SiteLayout({ children }: Props) {
  return (
    <>
      <Navbar />
      <main>{children}</main>
    </>
  );
}