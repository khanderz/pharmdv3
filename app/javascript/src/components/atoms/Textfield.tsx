import React from "react";
import {
  TextField as MuiTextField,
  TextFieldProps as MuiTextFieldProps,
} from "@mui/material";
import { Tooltip, TooltipProps } from "./Tooltip";

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
    <>
      {tooltipMessage && tooltipMessage.trim() !== "" && (
        <Tooltip
          id={props.id}
          tooltipMessage={tooltipMessage}
          placement="top"
          readMoreLink={readMoreLink}
        />
      )}
      <MuiTextField {...props} data-testid={`${props.id}-textfield`} />
    </>
  );
};
