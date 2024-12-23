import React from "react";

import {
  Tooltip as MuiTooltip,
  TooltipProps as MuiTooltipProps,
} from "@mui/material";

export interface TooltipProps extends MuiTooltipProps {
  id: string;
}

export const Tooltip = ({ id, children, ...props }: TooltipProps) => {
  return (
    <MuiTooltip {...props} data-testid={`${id}-tooltip`} arrow open={true}>
      {children}
    </MuiTooltip>
  );
};
