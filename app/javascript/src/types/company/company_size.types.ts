import { useState, useEffect } from 'react';
import { useCompanySizes } from '@javascript/hooks';

const [companySizes, setCompanySizes] = useState<
  {
    id: number;
    size_range: string;
  }[]
>([]);

const { companySizes: allCompanySizes } = useCompanySizes();

useEffect(() => {
  if (allCompanySizes) {
    setCompanySizes(allCompanySizes);
  }
}, [allCompanySizes]);

export type CompanySizes = (typeof companySizes)[number];

export interface CompanySize {
  id: number;
  size_range: CompanySizes['size_range'];
}
