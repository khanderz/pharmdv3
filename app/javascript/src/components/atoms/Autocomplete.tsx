import React from "react";
import { Autocomplete as MuiAutocomplete, Box } from "@mui/material";
import { TextField } from "./Textfield";
import { TooltipProps } from "./Tooltip";

export interface AutocompleteOption {
  key: string | number;
  value: string | number;
}

export type AutocompleteProps = {
  inputLabel: string;
  options: AutocompleteOption[];
  value: AutocompleteOption | AutocompleteOption[] | null;
  multiple?: boolean;
  id?: string;
  loading?: boolean;
  onChange: (
    event: React.SyntheticEvent<Element, Event>,
    value: AutocompleteOption | AutocompleteOption[] | null,
  ) => void;
  sx?: Record<string, any>;
  inputValue?: string;
  onInputChange?: (event: React.ChangeEvent<{}>, value: string) => void;
  disable?: boolean;
  tooltipMessage?: TooltipProps["tooltipMessage"];
  readMoreLink?: TooltipProps["readMoreLink"];
};

export const Autocomplete = ({
  inputLabel,
  options,
  value,
  multiple = false,
  id,
  loading = false,
  onChange,
  sx,
  inputValue,
  onInputChange,
  disable = false,
  tooltipMessage,
  readMoreLink,
}: AutocompleteProps) => {
  const valueProp = value ?? (multiple ? [] : null);

  return (
    <Box
      data-testid={`${id}-autocomplete-box`}
      sx={{
        mt: 2,
        ...sx,
      }}
    >
      <MuiAutocomplete
        fullWidth
        disabled={disable}
        data-testid={`${id}-autocomplete`}
        value={valueProp}
        multiple={multiple}
        id={id}
        options={options}
        onChange={(e, newValue) => {
          onChange(e, newValue ?? (multiple ? [] : null));
        }}
        loadingText="Loading..."
        loading={loading}
        sx={{
          mt: "2em",
        }}
        getOptionLabel={option => {
          return option?.value?.toString();
        }}
        inputValue={inputValue}
        onInputChange={onInputChange}
        renderInput={params => (
          <TextField
            {...params}
            id={id}
            label={inputLabel}
            disabled={disable}
            variant="outlined"
            placeholder={inputLabel}
            sx={{
              backgroundColor: disable ? "grayscale.disabled" : "transparent",
            }}
            tooltipMessage={tooltipMessage}
            readMoreLink={readMoreLink}
          />
        )}
      />
    </Box>
  );
};
