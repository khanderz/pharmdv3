import { createTheme } from '@mui/material/styles';

type CustomTheme = {
  [Key in keyof typeof theme]: (typeof theme)[Key];
};

declare module '@mui/material/styles' {
  interface Theme extends CustomTheme {}
  interface ThemeOptions extends CustomTheme {}
}

declare module '@mui/material/Typography' {
  interface TypographyPropsVariantOverrides {
    title: true;
  }
}

export const theme = {
  palette: {
    primary: {
      main: '#226f54', // Dark Spring Green
      light: '#66c1aa',
      dark: '#184e3b',
      hover: '#1a5b45',
      disabled: '#a5d1be',
      contrastText: '#F9EEEE',
    },
    secondary: {
      main: '#84AFE6', // Orchid Blue
      light: '#b3d1f7',
      dark: '#5a8bc2',
      hover: '#cc2e2b',
      disabled: '#f7a5a5',
      contrastText: '#1e1e1e',
    },
    error: {
      main: '#E53935', // Strong Red
      light: '#FFCDD2',
      dark: '#9a0000',
      hover: '#cc2e2b',
      disabled: '#f7a5a5',
      contrastText: '#F9EEEE',
    },
    warning: {
      main: '#F57C00', // Vibrant Orange
      light: '#FFD180',
      dark: '#E65100',
      hover: '#db7100',
      disabled: '#ffcc99',
      contrastText: '#F9EEEE',
    },
    success: {
      main: '#3DA35D', // Lush Green
      light: '#92CDA4',
      dark: '#1c5942',
      hover: '#369250',
      disabled: '#a7d7b9',
      contrastText: '#F9EEEE',
    },
    info: {
      main: '#9a0000', // Off Red
      light: '#d84545',
      dark: '#6e0000',
      hover: '#820000',
      disabled: '#e3a4a4',
      contrastText: '#F9EEEE',
    },
    grayscale: {
      main: '#d1cfe2', // Grayish Lavender
      light: '#f0eff9',
      dark: '#a5a3b6',
      hover: '#b9b8cf',
      disabled: '#eae8f3',
      contrastText: '#333333',
    },
  },
  typography: {
    fontFamily: ['Archivo', 'Arial', 'sans-serif'].join(','),
    title: {
      fontSize: '2rem',
      fontWeight: 100,
      fontFamily: ['Archivo', 'Arial', 'sans-serif'].join(','),
      letterSpacing: '0.1em',

      lineHeight: 1.4,
    },
    h1: {
      fontSize: '3rem',
      fontWeight: 700,
      letterSpacing: '0.05em',
      lineHeight: 1.4,
    },
    h2: {
      fontSize: '2.5rem',
      fontWeight: 700,
      letterSpacing: '0.05em',
      lineHeight: 1.4,
    },
    h3: {
      fontSize: '2rem',
      fontWeight: 700,
      letterSpacing: '0.05em',
      lineHeight: 1.4,
    },
    h4: {
      fontSize: '1.5rem',
      fontWeight: 700,
      letterSpacing: '0.05em',
      lineHeight: 1.4,
    },
    h5: {
      fontSize: '1.25rem',
      fontWeight: 700,
      letterSpacing: '0.05em',
      lineHeight: 1.4,
    },
    h6: {
      fontSize: '1rem',
      fontWeight: 700,
      letterSpacing: '0.05em',
      lineHeight: 1.4,
    },
    body1: {
      fontSize: '1rem',
      fontWeight: 400,
      letterSpacing: '0.05em',
      lineHeight: 1.4,
    },
    body2: {
      fontSize: '0.875rem',
      fontWeight: 400,
      letterSpacing: '0.05em',
      lineHeight: 1.4,
    },
    subtitle1: {
      fontSize: '1rem',
      fontWeight: 400,
      letterSpacing: '0.05em',
      lineHeight: 1.4,
    },
    subtitle2: {
      fontSize: '0.875rem',
      fontWeight: 400,
      letterSpacing: '0.05em',
      lineHeight: 1.4,
    },
  },
  components: {
    MuiButton: {
      styleOverrides: {
        root: {
          textTransform: 'none',
          borderRadius: 2,
          letterSpacing: '0.08em',
        },
      },
    },
    MuiTextField: {
      styleOverrides: {
        root: {
          '& .MuiOutlinedInput-root': {
            borderRadius: '2px',
            '& fieldset': {
              borderColor: 'primary.main', // double check these work or change back to hex
            },
            '&:hover fieldset': {
              borderColor: 'primary.main',
            },
            '&.Mui-focused fieldset': {
              borderColor: 'primary.main',
            },
          },
        },
      },
    },
    MuiSelect: {
      styleOverrides: {
        root: {
          borderRadius: '2px',
          '&:hover': {
            backgroundColor: '#e0e0e0',
          },
        },
        icon: {
          color: '#226f54',
        },
      },
    },
    MuiMenuItem: {
      styleOverrides: {
        root: {
          fontSize: '1rem',
          padding: '8px 16px',
          '&.Mui-focusVisible': {
            backgroundColor: '#226f54', // Set your primary color for focused state
            color: '#ffffff', // Text color when focused
          },
          '&.Mui-selected': {
            backgroundColor: '#226f54',
            color: '#F9EEEE', // Text color when selected
            '&:hover': {
              backgroundColor: '#184e3b', // Darker shade when both selected and hovered
              color: '#ffffff', // Text color when both selected and hovered
            },
          },
          '&:hover': {
            backgroundColor: '#226f54',
            color: '#ffffff', // Text color on hover
          },
          '&.Mui-focusVisible.Mui-selected': {
            backgroundColor: '#184e3b', // Darker primary color when both selected and focused
            color: '#ffffff', // Text color when both selected and focused
          },
        },
      },
    },
  },
} as const;

const customTheme = createTheme(theme);

export default customTheme;
