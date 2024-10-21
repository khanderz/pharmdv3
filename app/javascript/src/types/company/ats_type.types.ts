export enum AtsTypeEnum {
    ASHBYHQ = 'AshbyHQ',
    BAMBOOHR = 'BambooHR',
    BREEZYHR = 'BreezyHR',
    BUILTIN = 'BuiltIn',
    DOVER = 'Dover',
    EIGHTFOLD = 'Eightfold',
    FOUNTAIN = 'Fountain',
    GREENHOUSE = 'Greenhouse',
    ICIMS = 'iCIMS',
    JAZZHR = 'JazzHR',
    LEVER = 'Lever',
    MYWORKDAY = 'MyWorkday',
    PINPOINTHQ = 'PinpointHQ',
    PROPRIETARY = 'Proprietary',
    RIPPLING = 'Rippling',
    SMARTRECRUITERS = 'SmartRecruiters',
    TALEO = 'Taleo',
    WELLFOUND = 'Wellfound',
    WORKABLE = 'Workable',
    YCOMBINATOR = 'YCombinator',
}

export interface AtsType {
    id: number;
    ats_type_code: keyof typeof AtsTypeEnum;
    ats_type_name: typeof AtsTypeEnum[keyof typeof AtsTypeEnum];
}
