import { useState, useEffect } from "react";
import { useHealthcareDomains } from "@javascript/hooks";

const [healthcareDomains, setHealthcareDomains] = useState<
  { id: number; key: string; value: string }[]
>([]);

const { allDomains } = useHealthcareDomains();

useEffect(() => {
  if (allDomains) {
    setHealthcareDomains(allDomains);
  }
}, [allDomains]);

export type HealthcareDomains = (typeof healthcareDomains)[number];

export interface HealthcareDomain {
  id: number;
  key: HealthcareDomains["key"];
  value: HealthcareDomains["value"];
}
