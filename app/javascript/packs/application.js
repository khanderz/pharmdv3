import React from 'react'; // Import React
import ReactOnRails from 'react-on-rails';
import NavBar from '../bundles/NavBar/NavBarServer'; // Client-side version
import { createRoot } from 'react-dom/client';
import { ThemeProvider } from '@mui/material/styles';
import theme from '../designSystem/theme'; // Import your global theme

ReactOnRails.register({ NavBar });

document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('app-container'); // A global container for the entire app

  if (container) {
    const root = createRoot(container);

    // Wrap the entire app with ThemeProvider to apply the theme globally
    root.render(
      <ThemeProvider theme={theme}>
        <NavBar /> {/* Render the NavBar globally */}
        {/* Here you can conditionally render other components */}
      </ThemeProvider>
    );
  }

  const controllerName = document.body.getAttribute('data-controller');
  const actionName = document.body.getAttribute('data-action');

  if (controllerName === 'search' && actionName === 'searchPage') {
    import('../bundles/SearchPageBundle')
      .then((SearchPageModule) => {
        const SearchPage = SearchPageModule.default;

        ReactOnRails.register({ SearchPage });

        const searchContainer = document.getElementById('search-page-container');

        if (searchContainer) {
          const searchRoot = createRoot(searchContainer);

          searchRoot.render(<SearchPage />);
        } else {
          console.error('SearchPage container not found!');
        }
      })
      .catch((error) => {
        console.error('Error loading SearchPageBundle:', error);
      });
  } else if (controllerName === 'directory') {
    import('../bundles/DirectoryBundle')
      .then((DirectoryModule) => {
        const Directory = DirectoryModule.default;

        ReactOnRails.register({ Directory });

        const directoryContainer = document.getElementById('directory-container');

        if (directoryContainer) {
          const directoryRoot = createRoot(directoryContainer);
          // No need to wrap again with ThemeProvider because it's already global
          directoryRoot.render(<Directory />);
        } else {
          console.error('Directory container not found!');
        }

        ReactOnRails.reactOnRailsPageLoaded();
      })
      .catch((error) => {
        console.error('Error loading DirectoryBundle:', error);
      });
  }
});
