import React from "react";
import {
  TextField as MuiTextField,
  TextFieldProps as MuiTextFieldProps,
} from "@mui/material";
import { Tooltip, TooltipProps } from "./Tooltip";
import { Box } from "./Box";

export interface TextFieldProps extends MuiTextFieldProps {
  tooltipMessage?: TooltipProps["tooltipMessage"];
  readMoreLink?: TooltipProps["readMoreLink"];
}

export const TextField = ({
  tooltipMessage,
  readMoreLink,
  ...props
}: TextFieldProps) => {
  return (
    <Box id={props.id}>
      {tooltipMessage && tooltipMessage.trim() !== "" && (
        <Tooltip
          id={props.id}
          {...props}
          tooltipMessage={tooltipMessage}
          readMoreLink={readMoreLink}
          slotProps={{
            popper: {
              placement: "top-end",
            },
          }}
        />
      )}
      <MuiTextField {...props} data-testid={`${props.id}-textfield`} />
    </Box>
  );
};
