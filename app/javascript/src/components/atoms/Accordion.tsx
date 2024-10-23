import React from 'react';
import {
  Accordion as MuiAccordion,
  AccordionProps as MuiAccordionProps,
} from '@mui/material';

export interface AccordionProps extends MuiAccordionProps {}

export const Accordion = ({ ...props }: AccordionProps) => {
  return (
    <MuiAccordion
      {...props}
      sx={{
        display: 'flex',
        flexDirection: 'column',
        border: '1px solid',
        borderColor: 'primary.main',
        borderRadius: '2px',
        p: 1,
        ...props.sx,
      }}
    ></MuiAccordion>
  );
};
