import { useState, useEffect } from 'react';
import { useHealthcareDomains } from '@javascript/hooks';

const [healthcareDomains, setHealthcareDomains] = useState<
  { id: number; key: string; value: string }[]
>([]);

const { allDomains } = useHealthcareDomains();

useEffect(() => {
  if (allDomains) {
    setHealthcareDomains(allDomains);
  }
}, [allDomains]);

export type HealthcareDomainEnum = (typeof healthcareDomains)[number]['value'];
export type HealthcareDomainKey = (typeof healthcareDomains)[number]['key'];

export interface HealthcareDomain {
  id: number;
  key: HealthcareDomainKey;
  value: HealthcareDomainEnum;
}
