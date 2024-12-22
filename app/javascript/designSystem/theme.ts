import { createTheme } from "@mui/material/styles";

type CustomTheme = {
  [Key in keyof typeof theme]: (typeof theme)[Key];
};

declare module "@mui/material/styles" {
  interface Theme extends CustomTheme {}
  interface ThemeOptions extends CustomTheme {}
}

declare module "@mui/material/Typography" {
  interface TypographyPropsVariantOverrides {
    title: true;
  }
}

const fontFamily = ["Archivo", "Arial", "sans-serif"].join(",");

export const theme = {
  palette: {
    primary: {
      main: "#226f54", // Dark Spring Green
      light: "#66c1aa",
      lightest: "#cce8d8",
      dark: "#184e3b",
      hover: "#1a5b45",
      disabled: "#a5d1be",
      contrastText: "#F9EEEE",
    },
    secondary: {
      main: "#84AFE6", // Orchid Blue
      light: "#b3d1f7",
      dark: "#5a8bc2",
      hover: "#cc2e2b",
      disabled: "#f7a5a5",
      contrastText: "#1e1e1e",
    },
    error: {
      main: "#E53935", // Strong Red
      light: "#FFCDD2",
      dark: "#9a0000",
      hover: "#cc2e2b",
      disabled: "#f7a5a5",
      contrastText: "#F9EEEE",
    },
    warning: {
      main: "#F57C00", // Vibrant Orange
      light: "#FFD180",
      dark: "#E65100",
      hover: "#db7100",
      disabled: "#ffcc99",
      contrastText: "#F9EEEE",
    },
    success: {
      main: "#3DA35D", // Lush Green
      light: "#92CDA4",
      dark: "#1c5942",
      hover: "#369250",
      disabled: "#a7d7b9",
      contrastText: "#F9EEEE",
    },
    info: {
      main: "#9a0000", // Off Red
      light: "#d84545",
      dark: "#6e0000",
      hover: "#820000",
      disabled: "#e3a4a4",
      contrastText: "#F9EEEE",
    },
    grayscale: {
      main: "#d1cfe2", // Grayish Lavender
      light: "#f0eff9",
      dark: "#a5a3b6",
      hover: "#b9b8cf",
      disabled: "#eae8f3",
      contrastText: "#333333",
    },
  },
  typography: {
    fontFamily: fontFamily,
    title: {
      fontSize: "2rem",
      fontWeight: 100,
      fontFamily: fontFamily,
      letterSpacing: "0.1em",

      lineHeight: 1.4,
    },
    h1: {
      fontSize: "3rem",
      fontWeight: 700,
      letterSpacing: "0.05em",
      lineHeight: 1.4,
    },
    h2: {
      fontSize: "2.5rem",
      fontWeight: 700,
      letterSpacing: "0.05em",
      lineHeight: 1.4,
    },
    h3: {
      fontSize: "2rem",
      fontWeight: 700,
      letterSpacing: "0.05em",
      lineHeight: 1.4,
    },
    h4: {
      fontSize: "1.5rem",
      fontWeight: 700,
      letterSpacing: "0.05em",
      lineHeight: 1.4,
    },
    h5: {
      fontSize: "1.25rem",
      fontWeight: 700,
      letterSpacing: "0.05em",
      lineHeight: 1.4,
    },
    h6: {
      fontSize: "1rem",
      fontWeight: 700,
      letterSpacing: "0.05em",
      lineHeight: 1.4,
    },
    body1: {
      fontSize: "1rem",
      fontWeight: 400,
      letterSpacing: "0.05em",
      lineHeight: 1.4,
    },
    body2: {
      fontSize: "0.875rem",
      fontWeight: 400,
      letterSpacing: "0.05em",
      lineHeight: 1.4,
    },
    subtitle1: {
      fontSize: "1rem",
      fontWeight: 400,
      letterSpacing: "0.05em",
      lineHeight: 1.4,
    },
    subtitle2: {
      fontSize: "0.875rem",
      fontWeight: 400,
      letterSpacing: "0.05em",
      lineHeight: 1.4,
    },
    key: {
      fontSize: "0.9rem",
      fontWeight: 700,
      letterSpacing: "0.05em",
      lineHeight: 1.4,
      fontFamily: fontFamily,
    },
  },
  components: {
    MuiButton: {
      styleOverrides: {
        root: {
          textTransform: "none",
          borderRadius: 2,
          letterSpacing: "0.08em",
        },
      },
    },
    MuiTextField: {
      styleOverrides: {
        root: {
          "& .MuiOutlinedInput-root": {
            borderRadius: "2px",
            "& fieldset": {
              borderColor: "#226f54",
            },
            "&:hover fieldset": {
              borderColor: "#226f54",
            },
            "&.Mui-focused fieldset": {
              borderColor: "#226f54",
            },
          },
        },
      },
    },
    MuiAutocomplete: {
      styleOverrides: {
        root: {
          boxShadow: "3px 3px 0px 0px #000000",
          "&:hover": {
            backgroundColor: "#f0eff9",
          },
        },
        endAdornment: {
          ".MuiAutocomplete-popupIndicator": {
            color: "#226f54",
          },
          ".MuiAutocomplete-clearIndicator": {
            color: "#226f54",
            "&:hover": {
              backgroundColor: "#cce8d8",
              color: "#184e3b",
            },
          },
        },
        tag: {
          backgroundColor: "#cce8d8",
          "& .MuiChip-deleteIcon": {
            color: "#226f54",
            "&:hover": {
              backgroundColor: "#cce8d8",
              color: "#184e3b",
            },
          },
        },
        popper: {
          "& .MuiPopper-root, &.MuiAutocomplete-popper": {
            border: "2px solid #000000",
            boxShadow: "3px 3px 0px 0px #000000",
          },
        },
      },
    },
    // MuiMenuItem: {
    //   styleOverrides: {
    //     root: {
    //       fontSize: '1rem',
    //       padding: '8px 16px',
    //       '&.Mui-focusVisible': {
    //         backgroundColor: '#226f54',
    //         color: '#ffffff',
    //       },
    //       '&.Mui-selected': {
    //         backgroundColor: '#226f54',
    //         color: '#F9EEEE',
    //         '&:hover': {
    //           backgroundColor: '#184e3b',
    //           color: '#ffffff',
    //         },
    //       },
    //       '&:hover': {
    //         backgroundColor: '#226f54',
    //         color: '#ffffff',
    //       },
    //       '&.Mui-focusVisible.Mui-selected': {
    //         backgroundColor: '#184e3b',
    //         color: '#ffffff',
    //       },
    //     },
    //   },
    // },
  },
} as const;

const customTheme = createTheme(theme);

export default customTheme;
