export enum FundingTypeEnum {
    ANGEL = 'Angel',
    CONVERTIBLE_NOTE = 'Convertible Note',
    CORPORATE_ROUND = 'Corporate Round',
    DEBT_FINANCING = 'Debt Financing',
    EQUITY_CROWDFUNDING = 'Equity Crowdfunding',
    GRANT = 'Grant',
    INITIAL_COIN_OFFERING = 'Initial Coin Offering',
    NON_EQUITY_ASSISTANCE = 'Non-Equity Assistance',
    POST_IPO_DEBT = 'Post IPO Debt',
    POST_IPO_EQUITY = 'Post IPO Equity',
    POST_IPO_SECONDARY = 'Post IPO Secondary',
    PRE_SEED = 'Pre Seed',
    PRIVATE_EQUITY = 'Private Equity',
    PRODUCT_CROWDFUNDING = 'Product Crowdfunding',
    SECONDARY_MARKET = 'Secondary Market',
    SEED = 'Seed',
    SERIES_A = 'Series A',
    SERIES_B = 'Series B',
    SERIES_C = 'Series C',
    SERIES_D = 'Series D',
    SERIES_E = 'Series E',
    SERIES_F = 'Series F',
    SERIES_G = 'Series G',
    SERIES_H = 'Series H',
    SERIES_I = 'Series I',
    SERIES_J = 'Series J',
    SERIES_UNKNOWN_VENTURE = 'Series Unknown Venture',
    UNDISCLOSED = 'Undisclosed',
    OTHER = 'Other',
}

export interface FundingType {
    funding_type_id: number;
    funding_type_code: keyof typeof FundingTypeEnum;
    funding_type_name: typeof FundingTypeEnum[keyof typeof FundingTypeEnum];
}