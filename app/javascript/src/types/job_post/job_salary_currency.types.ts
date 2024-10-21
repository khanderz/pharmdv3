import { Adjudication } from "../adjudication.types";

export enum JobSalaryCurrencyEnum {
    AUD = 'AUD', // Australian Dollar
    BRL = 'BRL', // Brazilian Real
    CAD = 'CAD', // Canadian Dollar
    CHF = 'CHF', // Swiss Franc
    CNY = 'CNY', // Chinese Yuan
    EUR = 'EUR', // Euro
    GBP = 'GBP', // British Pound Sterling
    INR = 'INR', // Indian Rupee
    JPY = 'JPY', // Japanese Yen
    KRW = 'KRW', // South Korean Won
    NZD = 'NZD', // New Zealand Dollar
    SEK = 'SEK', // Swedish Krona
    SGD = 'SGD', // Singapore Dollar
    USD = 'USD', // US Dollar
    ZAR = 'ZAR'  // South African Rand
}

export interface JobSalaryCurrency {
    job_salary_currency_id: number;
    job_salary_currency_key: keyof typeof JobSalaryCurrencyEnum;
    currrency_code: typeof JobSalaryCurrencyEnum[keyof typeof JobSalaryCurrencyEnum];
    reference_id?: Adjudication['adjudicatable_id'];
    error_details?: Adjudication['error_details'];
    resolved: Adjudication['resolved'];
}