import { Company } from "@customtypes/company/company.types";
import * as xDataGridPro from "@mui/x-data-grid-pro";

interface TableDataProps {
  data: Array<Company>;
  dataAccessors: Array<(row: xDataGridPro.HeaderProps) => any>;
}

export const getTableData = ({
  data,
  dataAccessors,
}: TableDataProps): Array<Company> => {
  const tableData = data.map((value: Company) => {
    const row: Company = {
      company_id: value?.company_id || 0,
      company_name: value?.company_name || "",
      healthcare_domains: value?.healthcare_domains.map(obj => obj.value) || [],
      company_size: value?.company_size.size_range || 0,
      operating_status: value?.operating_status || false,
    };
    dataAccessors?.forEach((key: string, indexNumber: number) => {
      (row as any)[key] = value[key];
      row.id = value?.["id"];
    });
    return row;
  });

  return tableData;
};
