import { Adjudicated } from "../adjudication.types";

export interface Benefits extends Adjudicated {
  id: number;
  benefit_name: string;
  benefit_category: string;
}
