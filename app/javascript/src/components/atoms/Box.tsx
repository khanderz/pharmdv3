import React from "react";
import { Box as MuiBox, BoxProps as MuiBoxProps } from "@mui/material";

export interface BoxProps extends MuiBoxProps {
}

export const Box = ({
    ...props
}: BoxProps) => {

    return (
        <MuiBox {...props}
            sx={{
                border: '1px solid #226f54',
                borderRadius: '2px',
                ...props.sx
            }}
        ></MuiBox>
    )
}