import React from "react";
import { Button as MuiButton, ButtonProps as MuiButtonProps } from "@mui/material";

export interface ButtonProps extends MuiButtonProps {
}

export const Button = ({
    ...props
}: ButtonProps) => {

    return (
        <MuiButton {...props}
            sx={{
                border: '2px solid #000000',
                boxShadow: '3px 3px 0px 0px #000000',
                ...props.sx
            }}
        ></MuiButton>
    )
}