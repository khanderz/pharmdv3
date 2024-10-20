import { createTheme } from '@mui/material/styles';

interface Grayscale {
    main: string,
    dark: string,
    light: string,
    contrastText: string,
}
declare module '@mui/material/styles' {
    interface Palette {
        primary: Palette['primary'],
        secondary: Palette['secondary'],
        warning: Palette['warning'],
        success: Palette['success'],
        info: Palette['info'],
        grayscale: Grayscale
    }

    interface PaletteOptions {
        primary?: PaletteOptions['primary'],
        secondary?: PaletteOptions['secondary'],
        warning?: PaletteOptions['warning'],
        success?: PaletteOptions['success'],
        info?: PaletteOptions['info'],
        grayscale?: Grayscale
    }
}

export const theme = createTheme({
    palette: {
        primary: {
            main: '#226f54',  // Dark Spring Green
            light: '#72e1d1', // Turquoise
            dark: '#1c5942',  // Darker version of Dark Spring Green
            contrastText: '#ffffff',  // White text for contrast
        },
        secondary: {
            main: '#f9eeee',  // Lavender Blush
            dark: '#f0dddd',  // Darker version of Lavender Blush
            contrastText: '#9a0000',  // Penn Red as contrast text
        },
        warning: {
            main: '#fb0000',  // Off Red
            dark: '#9a0000',  // Penn Red as dark warning
            light: '#f9eeee', // Lightest warning variant
            contrastText: '#ffffff',  // White text
        },
        success: {
            main: '#226f54',  // Dark Spring Green for success
            light: '#72e1d1', // Light success (Turquoise)
            dark: '#1c5942',  // Dark success variant
            contrastText: '#ffffff',  // White text
        },
        info: {
            main: '#72e1d1',  // Turquoise for informational messages
            dark: '#56b6a3',  // Darker info variant
            contrastText: '#ffffff',  // White text
        },
        grayscale: {
            main: '#f5f5f5',  // Light grayscale (secondary)
            dark: '#e0e0e0',  // Darker grayscale
            light: '#ffffff', // Lightest grayscale (white)
            contrastText: '#9a0000',  // Contrast text for grayscale
        },
    },
    typography: {
        fontFamily: ['"Open Sans"', 'Arial', 'sans-serif'].join(','),
        h1: {
            fontSize: '3rem',
            fontWeight: 700,
        },
        h2: {
            fontSize: '2.5rem',
            fontWeight: 700,
        },
        h3: {
            fontSize: '2rem',
            fontWeight: 700,
        },
        h4: {
            fontSize: '1.5rem',
            fontWeight: 700,
        },
        h5: {
            fontSize: '1.25rem',
            fontWeight: 700,
        },
        h6: {
            fontSize: '1rem',
            fontWeight: 700,
        },
        body1: {
            fontSize: '1rem',
            fontWeight: 400,
        },
        body2: {
            fontSize: '0.875rem',
            fontWeight: 400,
        },
        subtitle1: {
            fontSize: '1rem',
            fontWeight: 400,
        },
        subtitle2: {
            fontSize: '0.875rem',
            fontWeight: 400,
        },
    },
});

export default theme;
