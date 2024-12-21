import { GridCellParams, GridColDef } from "@mui/x-data-grid";
import React from "react";
import { KeyboardArrowUp, KeyboardArrowDown } from "@mui/icons-material";

interface TableHeaderProps {
  open: boolean;
}

export interface HeaderProps {
  headerName: string;
  field: string;
  nestedKey: string | null;
  flex: number;
  type: string;
  headerAlign: string;
  align: string;
  renderCell?: (params: GridCellParams) => React.ReactNode;
}

export const dataHeaders: HeaderProps[] = ({
  open,
}: TableHeaderProps): GridColDef[] => {
  type GridAlignment = "left" | "right" | "center";

  return [
    {
      headerName: "",
      field: "openJobs",
      flex: 0.5,
      type: "singleSelect",
      headerAlign: "center" as GridAlignment,
      align: "center",
      renderCell: (params: GridCellParams) =>
        open ? <KeyboardArrowUp /> : <KeyboardArrowDown />,
    },
    {
      headerName: "Company Name",
      field: "company_name",
      nestedKey: null,
      flex: 1,
      type: "string",
      headerAlign: "center" as GridAlignment,
      align: "center",
    },
    {
      headerName: "Healthcare Domains",
      field: "healthcare_domains",
      nestedKey: "value",
      flex: 1,
      type: "array",
      headerAlign: "center" as GridAlignment,
      align: "center",
    },
    {
      headerName: "Company Size",
      field: "company_size",
      nestedKey: "size_range",
      flex: 1,
      type: "number",
      headerAlign: "center" as GridAlignment,
      align: "center",
    },
    {
      headerName: "Company Active",
      field: "operating_status",
      nestedKey: null,
      flex: 1,
      type: "boolean",
      headerAlign: "center" as GridAlignment,
      align: "center",
    },
  ];
};
