import { Navbar } from "@/shared/components/layout/Navbar";
import { PageNavigation } from "@/shared/components/navigation/PageNavigation";

type Props = {
  children: React.ReactNode;
};

export function SiteLayout({ children }: Props) {
  return (
    <>
      <Navbar />
      <PageNavigation />
      <main>{children}</main>
    </>
  );
}