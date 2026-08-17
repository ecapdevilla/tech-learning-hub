"use client";

import { useEffect, useState } from "react";
import QRCode from "qrcode";

export function RoomQr({ value }: { value: string }) {
  const [src, setSrc] = useState("");

  useEffect(() => {
    let active = true;

    void QRCode.toDataURL(value, {
      width: 360,
      margin: 1,
      errorCorrectionLevel: "M",
    }).then((result) => {
      if (active) setSrc(result);
    });

    return () => {
      active = false;
    };
  }, [value]);

  if (!src) {
    return <div className="live-qr-loading">Generating QR…</div>;
  }

  return (
    // Data-URL QR images are generated client-side and do not benefit from next/image.
    // eslint-disable-next-line @next/next/no-img-element
    <img className="live-qr" src={src} alt="QR code to join game" />
  );
}
