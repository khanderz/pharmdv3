import { Company } from '../components/Directory/Directory.types';

interface TableDataProps {
  data: Array<Company>;
  dataAccessors: Array<string>;
}

export interface CompanyRowProps {
  id: Company['companyId'];
  companyName: Company['companyName'];
  companyType: Company['companyType'];
  companyAtsType: Company['companyAtsType'];
  companySize: Company['companySize'];
  operatingStatus: Company['operatingStatus'];
}

export const getTableData = ({
  data,
  dataAccessors,
}: TableDataProps): Array<CompanyRowProps> => {
  function snakeToCamel(obj: any): any {
    if (Array.isArray(obj)) {
      return obj.map((item) => snakeToCamel(item));
    } else if (obj !== null && typeof obj === 'object') {
      return Object.keys(obj).reduce((acc, key) => {
        const camelKey = key.replace(/_([a-z])/g, (match, p1) =>
          p1.toUpperCase()
        );
        acc[camelKey] = snakeToCamel(obj[key]);
        return acc;
      }, {} as any);
    }
    return obj;
  }

  const parsedData = snakeToCamel(data);

  const TableData = parsedData?.map((value: any) => {
    const row: CompanyRowProps = {
      id: value?.companyId || 0,
      companyName: '',
      companyType: '',
      companyAtsType: '',
      companySize: 0,
      operatingStatus: false,
    };
    dataAccessors?.forEach((key: string, indexNumber: number) => {
      (row as any)[key] = value[key];
      row.id = value?.['id'];
    });
    return row;
  });

  return TableData;
};
