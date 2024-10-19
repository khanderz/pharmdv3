// app/javascript/design-system/theme.js

import { createTheme } from '@mui/material/styles';

// Helper function to read CSS variables
const getCSSVariable = (variable) =>
    getComputedStyle(document.documentElement).getPropertyValue(variable).trim();

// Define your theme using the CSS variables from colors.scss
const theme = createTheme({
    palette: {
        primary: {
            main: getCSSVariable('--primary-color'),
        },
        secondary: {
            main: getCSSVariable('--secondary-color'),
        },
        customBlue: {
            main: getCSSVariable('--custom-blue'),
        },
        customWarm: {
            main: getCSSVariable('--custom-warm'),
        },
    },
    typography: {
        fontFamily: getCSSVariable('--font-family') || ['"Roboto"', '"Helvetica"', '"Arial"', 'sans-serif'].join(','),
    },
});

export default theme;
