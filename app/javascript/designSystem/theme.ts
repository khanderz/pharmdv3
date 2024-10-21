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

    interface TypographyVariants {
        title: React.CSSProperties;
    }

    interface TypographyVariantsOptions {
        title?: React.CSSProperties;
    }
}

declare module '@mui/material/Typography' {
    interface TypographyPropsVariantOverrides {
        title: true;
    }
}

export const theme = createTheme({
    palette: {
        primary: {
            main: '#226f54',  // Dark Spring Green
            light: '#72e1d1',
            dark: '#1c5942',
            contrastText: '#ffffff',
        },
        secondary: {
            main: '#f9eeee',  // Lavender Blush
            dark: '#f0dddd',
            contrastText: '#9a0000',
        },
        warning: {
            main: '#fb0000',  // Off Red
            dark: '#9a0000',
            light: '#f9eeee',
            contrastText: '#ffffff',
        },
        success: {
            main: '#226f54',  // Dark Spring Green for success
            light: '#72e1d1',
            dark: '#1c5942',
            contrastText: '#ffffff',
        },
        info: {
            main: '#72e1d1',  // Turquoise for informational messages
            dark: '#56b6a3',
            contrastText: '#ffffff',
        },
        grayscale: {
            main: '#f5f5f5',
            dark: '#e0e0e0',
            light: '#ffffff',
            contrastText: '#9a0000',
        },
    },
    typography: {
        fontFamily: ['Archivo', 'Arial', 'sans-serif'].join(','),
        title: {
            fontSize: '2rem',
            fontFamily: ['Archivo', 'Arial', 'sans-serif'].join(','),
        },
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
