// app/javascript/src/types/company/funding_type.types.ts

import { useState, useEffect } from 'react';
import { useFundingTypes } from '@javascript/hooks';

const [fundingTypes, setFundingTypes] = useState<
  {
    id: number;
    funding_type_code: string;
    funding_type_name: string;
  }[]
>([]);

const { fundingTypes: allFundingTypes } = useFundingTypes();

useEffect(() => {
  if (allFundingTypes) {
    setFundingTypes(allFundingTypes);
  }
}, [allFundingTypes]);

export type FundingTypes = (typeof fundingTypes)[number];

export interface FundingType {
  id: number;
  funding_type_code: FundingTypes['funding_type_code'];
  funding_type_name: FundingTypes['funding_type_name'];
}
