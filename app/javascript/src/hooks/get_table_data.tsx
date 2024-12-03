import { Company } from '@customtypes/company/company.types';

interface TableDataProps {
  data: Array<Company>;
  dataAccessors: Array<string>;
}

export const getTableData = ({
  data,
  dataAccessors,
}: TableDataProps): Array<Company> => {
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
    const row: Company = {
      id: value?.id || 0,
      companyName: value?.companyName || '',
      companyType: value?.companyType || '',
      companySize: value?.companySize || 0,
      operatingStatus: value?.operatingStatus || false,
    };
    dataAccessors?.forEach((key: string, indexNumber: number) => {
      (row as any)[key] = value[key];
      row.id = value?.['id'];
    });
    return row;
  });

  return TableData;
};
