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
            main: '#226f54',   // Dark Spring Green
            light: '#66c1aa',
            dark: '#184e3b',
            contrastText: '#F9EEEE',
        },
        secondary: {
            main: '#84AFE6',   // Orchid Blue
            light: '#b3d1f7',
            dark: '#5a8bc2',
            contrastText: '#1e1e1e',
        },
        error: {
            main: '#E53935', // Strong Red 
            light: '#FFCDD2',
            dark: '#9a0000',
            contrastText: '#F9EEEE',
        },
        warning: {
            main: '#F57C00', // Vibrant Orange
            light: '#FFD180',
            dark: '#E65100',
            contrastText: '#F9EEEE',
        },
        success: {
            main: '#3DA35D', // Lush Green
            light: '#92CDA4',
            dark: '#1c5942',
            contrastText: '#F9EEEE',
        },
        info: {
            main: '#9a0000', // Off Red
            light: '#d84545',
            dark: '#6e0000',
            contrastText: '#F9EEEE',
        },
        grayscale: {
            main: '#d1cfe2', // Grayish Lavender
            light: '#f0eff9',
            dark: '#a5a3b6',
            contrastText: '#333333',
        },
    },
    typography: {
        fontFamily: ['Archivo', 'Arial', 'sans-serif'].join(','),
        title: {
            fontSize: '2rem',
            fontWeight: 100,
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
