import React from "react";

import {
  Tooltip as MuiTooltip,
  TooltipProps as MuiTooltipProps,
  Box,
  Typography,
  Link,
} from "@mui/material";
import ReadMoreIcon from "@mui/icons-material/ReadMore";

export interface TooltipProps extends MuiTooltipProps {
  id: string;
  tooltipMessage: string;
  readMoreLink?: string;
}

export const Tooltip = ({
  id,
  tooltipMessage,
  readMoreLink,
  children,
  ...props
}: TooltipProps) => {
  return (
    <MuiTooltip
      {...props}
      data-testid={`${id}-tooltip`}
      arrow
      open={true}
      placement="top"
      title={
        <Box
          flexDirection="row"
          display="flex"
          justifyContent="center"
          alignItems="center"
          columnGap={1}
        >
          <Typography variant="body2">{tooltipMessage}</Typography>
          {readMoreLink && (
            <Link
              href={readMoreLink}
              target="_blank"
              rel="noopener"
              sx={{ display: "flex", alignItems: "center" }}
            >
              <ReadMoreIcon sx={{ color: "info.light" }} />
            </Link>
          )}
        </Box>
      }
    />
  );
};
