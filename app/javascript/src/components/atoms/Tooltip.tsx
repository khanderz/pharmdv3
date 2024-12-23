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
  readMoreLink?: string;
}

export const Tooltip = ({
  id,
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
        <Box>
          <Typography variant="body2">{children}</Typography>
          {readMoreLink && (
            <Link
              href={readMoreLink}
              target="_blank"
              rel="noopener"
              sx={{ display: "flex", alignItems: "center", mt: 1 }}
            >
              <ReadMoreIcon fontSize="small" sx={{ mr: 0.5 }} />
              Read More
            </Link>
          )}
        </Box>
      }
    />
  );
};
