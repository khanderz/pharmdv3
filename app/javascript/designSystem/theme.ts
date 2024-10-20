// app/javascript/design-system/theme.js

import { createTheme } from '@mui/material/styles';

// Helper function to read CSS variables
const getCSSVariable = (variable: string) =>
    getComputedStyle(document.documentElement).getPropertyValue(variable).trim();

declare module '@mui/material/styles' {
    interface Palette {
        green: Palette['primary']
    }

    interface PaletteOptions {
        green?: PaletteOptions['primary']
    }

    // interface Theme extends CustomTheme {
    //     green: Palette['primary']
    // }

    // interface ThemeOptions extends CustomTheme {
    //     green?: PaletteOptions['primary']
    // }
}


export const theme = createTheme({
    palette: {
        green: {
            main: '#226f54', // Your custom green color
        },
        primary: {
            main: '#226f54', // Also set as primary color for easier usage
        },
    },
});

export default theme;

// type CustomTheme = {
//     [Key in keyof typeof theme]: typeof theme[Key]
// }

// declare module '@mui/material/Typography' {
//     interface TypographyPropsVariantOverrides { }
// }


// Function to create a theme after the DOM is loaded
// const useTheme = () => {
//     const primaryColor = getCSSVariable('--mui-palette-primary-main') || '#226f54'; // Fallback
//     const fontFamily = getCSSVariable('--font-family') || '"Roboto", "Helvetica", "Arial", sans-serif';

//     return createTheme({
//         cssVariables: true,
//         palette: {
//             primary: {
//                 main: primaryColor,
//             },
//         },
//         typography: {
//             fontFamily: fontFamily,
//         },
//     });
// };

// export default useTheme;
