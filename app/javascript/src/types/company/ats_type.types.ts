import { useState, useEffect } from "react";
import { useAtsTypes } from "@javascript/hooks";

const [atsTypes, setAtsTypes] = useState<
  {
    id: number;
    ats_type_code: string;
    ats_type_name: string;
    domain_matched_url?: string;
    redirect_url?: string;
    post_match_url?: string;
  }[]
>([]);

const { atsTypes: allAtsTypes } = useAtsTypes();

useEffect(() => {
  if (allAtsTypes) {
    setAtsTypes(allAtsTypes);
  }
}, [allAtsTypes]);

export type AtsTypes = (typeof atsTypes)[number];

export interface AtsType {
  id: number;
  ats_type_code: AtsTypes["ats_type_code"];
  ats_type_name: AtsTypes["ats_type_name"];
  domain_matched_url?: AtsTypes["domain_matched_url"];
  redirect_url?: AtsTypes["redirect_url"];
  post_match_url?: AtsTypes["post_match_url"];
}
