import * as xDataGridPro from "@mui/x-data-grid-pro";
import React from "react";
import { KeyboardArrowUp, KeyboardArrowDown } from "@mui/icons-material";
import { Chip } from "../components/atoms/Chip";

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
  renderCell?: (params: xDataGridPro.GridCellParams) => React.ReactNode;
}

export const dataHeaders: HeaderProps[] = ({
  open,
}: TableHeaderProps): xDataGridPro.GridColDef[] => {
  type GridAlignment = "left" | "right" | "center";

  return [
    {
      headerName: "",
      field: "openJobs",
      flex: 0.5,
      type: "singleSelect",
      headerAlign: "center" as GridAlignment,
      align: "center",
      renderCell: (params: xDataGridPro.GridCellParams) =>
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
      flex: 2,
      type: "array",
      headerAlign: "center" as GridAlignment,
      align: "center",
      renderCell: Chip,
    },
    {
      headerName: "Company Size",
      field: "company_size",
      nestedKey: "size_range",
      flex: 0.5,
      type: "number",
      headerAlign: "center" as GridAlignment,
      align: "center",
    },
    {
      headerName: "Company Active",
      field: "operating_status",
      nestedKey: null,
      flex: 0.5,
      type: "boolean",
      headerAlign: "center" as GridAlignment,
      align: "center",
    },
  ];
};
