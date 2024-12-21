import React from "react";
import ReactOnRails from "react-on-rails";
import NavBar from "../bundles/NavBar/NavBarServer"; // Client-side version
import SearchPage from "../bundles/SearchPageBundle"; // Client-side version
import { createRoot } from "react-dom/client";
import { ThemeProvider } from "@mui/material/styles";
import theme from "../designSystem/theme";
import { FiltersProvider } from "../src/providers/FiltersProvider";

ReactOnRails.register({ NavBar });

document.addEventListener("DOMContentLoaded", () => {
  const controllerName = document.body.getAttribute("data-controller");
  const container = document.getElementById("app-container");

  if (container) {
    const root = createRoot(container);

    root.render(
      <ThemeProvider theme={theme}>
        <FiltersProvider>
          <NavBar />
          {/* <SearchPage /> */}
        </FiltersProvider>
      </ThemeProvider>,
    );
  }

  if (controllerName === "directory") {
    import("../bundles/DirectoryBundle").then(DirectoryModule => {
      const Directory = DirectoryModule.default;

      ReactOnRails.register({ Directory });

      const directoryContainer = document.getElementById("directory-container");

      if (directoryContainer) {
        const directoryRoot = createRoot(directoryContainer);

        directoryRoot.render(
          <ThemeProvider theme={theme}>
            <FiltersProvider>
              <Directory />
            </FiltersProvider>
          </ThemeProvider>,
        );
      }
    });
  }

  if (controllerName === "search") {
    import("../bundles/SearchPageBundle")
      .then(SearchPageModule => {
        const SearchPage = SearchPageModule.default;

        ReactOnRails.register({ SearchPage });

        const searchContainer = document.getElementById("search-container");

        if (searchContainer) {
          const searchRoot = createRoot(searchContainer);

          searchRoot.render(
            <ThemeProvider theme={theme}>
              <FiltersProvider>
                <SearchPage />
              </FiltersProvider>
            </ThemeProvider>,
          );
        } else {
          console.error("Search container not found!");
        }
      })
      .catch(error => {
        console.error("Error loading SearchPageBundle:", error);
      });
  }
});
