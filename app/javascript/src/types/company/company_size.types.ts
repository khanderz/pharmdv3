export enum CompanySizeEnum {
    SMALL_1_10 = '1-10',
    SMALL_11_50 = '11-50',
    MEDIUM_51_200 = '51-200',
    MEDIUM_201_500 = '201-500',
    LARGE_501_1000 = '501-1000',
    LARGE_1001_5000 = '1001-5000',
    ENTERPRISE_5001_10000 = '5001-10000',
    ENTERPRISE_10001_PLUS = '10001+',
}

export interface CompanySize {
    company_size_id: number;
    size_range_code: keyof typeof CompanySizeEnum;
    size_range_name: typeof CompanySizeEnum[keyof typeof CompanySizeEnum];
}