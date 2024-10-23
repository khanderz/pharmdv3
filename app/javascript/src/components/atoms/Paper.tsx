import React from 'react';
import {
  Container as MuiContainer,
  ContainerProps as MuiContainerProps,
} from '@mui/material';

export interface ContainerProps extends MuiContainerProps {
  dataTestId: string;
}

export const Container = ({ dataTestId, ...props }: ContainerProps) => {
  return (
    <MuiContainer
      {...props}
      data-testid={`${dataTestId}-page-container`}
      sx={{
        display: 'flex',
        height: '100vh',
        width: '100vw',
        ...props.sx,
      }}
    ></MuiContainer>
  );
};
