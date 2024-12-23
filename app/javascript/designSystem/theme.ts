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

const primary_main = "#226f54";
const primary_light = "#66c1aa";
const primary_lightest = "#cce8d8";
const primary_dark = "#184e3b";
const primary_hover = "#1a5b45";
const primary_disabled = "#a5d1be";
const primary_contrastText = "#F9EEEE";

const secondary_main = "#84AFE6";
const secondary_light = "#b3d1f7";
const secondary_dark = "#5a8bc2";
const secondary_hover = "#cc2e2b";
const secondary_disabled = "#f7a5a5";
const secondary_contrastText = "#1e1e1e";

const error_main = "#E53935";
const error_light = "#FFCDD2";
const error_dark = "#9a0000";
const error_hover = "#cc2e2b";
const error_disabled = "#f7a5a5";
const error_contrastText = primary_contrastText;

const warning_main = "#F57C00";
const warning_light = "#FFD180";
const warning_dark = "#E65100";
const warning_hover = "#db7100";
const warning_disabled = "#ffcc99";
const warning_contrastText = primary_contrastText;

const success_main = "#3DA35D";
const success_light = "#92CDA4";
const success_dark = "#1c5942";
const success_hover = "#369250";
const success_disabled = "#a7d7b9";
const success_contrastText = primary_contrastText;

const info_main = "#9a0000";
const info_light = "#d84545";
const info_dark = "#6e0000";
const info_hover = "#820000";
const info_disabled = "#e3a4a4";
const info_contrastText = primary_contrastText;

const grayscale_main = "#d1cfe2";
const grayscale_light = "#f0eff9";
const grayscale_dark = "#a5a3b6";
const grayscale_hover = "#b9b8cf";
const grayscale_disabled = "#eae8f3";
const grayscale_contrastText = "#333333";

export const theme = {
  palette: {
    primary: {
      main: primary_main, // Dark Spring Green
      light: primary_light,
      lightest: primary_lightest,
      dark: primary_dark,
      hover: primary_hover,
      disabled: primary_disabled,
      contrastText: primary_contrastText,
    },
    secondary: {
      main: secondary_main, // Orchid Blue
      light: secondary_light,
      dark: secondary_dark,
      hover: secondary_hover,
      disabled: secondary_disabled,
      contrastText: secondary_contrastText,
    },
    error: {
      main: error_main, // Strong Red
      light: error_light,
      dark: error_dark,
      hover: error_hover,
      disabled: error_disabled,
      contrastText: error_contrastText,
    },
    warning: {
      main: warning_main, // Vibrant Orange
      light: warning_light,
      dark: warning_dark,
      hover: warning_hover,
      disabled: warning_disabled,
      contrastText: warning_contrastText,
    },
    success: {
      main: success_main, // Lush Green
      light: success_light,
      dark: success_dark,
      hover: success_hover,
      disabled: success_disabled,
      contrastText: success_contrastText,
    },
    info: {
      main: info_main, // Off Red
      light: info_light,
      dark: info_dark,
      hover: info_hover,
      disabled: info_disabled,
      contrastText: info_contrastText,
    },
    grayscale: {
      main: grayscale_main, // Grayish Lavender
      light: grayscale_light,
      dark: grayscale_dark,
      hover: grayscale_hover,
      disabled: grayscale_disabled,
      contrastText: grayscale_contrastText,
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
    MuiTooltip: {
      styleOverrides: {
        tooltip: {
          backgroundColor: primary_dark,
          color: primary_contrastText,
          fontSize: "0.875rem",
          fontFamily: fontFamily,
          letterSpacing: "0.05em",
          lineHeight: 1.4,
        },
        arrow: {
          color: primary_dark,
        },
      },
    },
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
              borderColor: primary_main,
            },
            "&:hover fieldset": {
              borderColor: grayscale_hover,
            },
            "&.Mui-focused fieldset": {
              borderColor: primary_main,
            },
            "&.Mui-disabled": {
              backgroundColor: grayscale_disabled,
              cursor: "default",
              pointerEvents: "auto",
            },
            "&.Mui-disabled:hover": {
              backgroundColor: grayscale_disabled,
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
            backgroundColor: grayscale_hover,
          },
        },
        endAdornment: {
          ".MuiAutocomplete-popupIndicator": {
            color: primary_main,
          },
          ".MuiAutocomplete-clearIndicator": {
            color: primary_main,
            "&:hover": {
              backgroundColor: primary_lightest,
              color: primary_dark,
            },
          },
        },
        tag: {
          backgroundColor: primary_lightest,
          "& .MuiChip-deleteIcon": {
            color: primary_main,
            "&:hover": {
              backgroundColor: primary_lightest,
              color: primary_dark,
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
