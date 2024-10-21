import React from 'react';
import ReactOnRails from 'react-on-rails';
import NavBar from '../bundles/NavBar/NavBarServer'; // Client-side version
import SearchPage from '../bundles/SearchPageBundle'; // Client-side version
import { createRoot } from 'react-dom/client';
import { ThemeProvider } from '@mui/material/styles';
import theme from '../designSystem/theme';

ReactOnRails.register({ NavBar });

document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('app-container');

  if (container) {
    const root = createRoot(container);

    root.render(
      <ThemeProvider theme={theme}>
        <NavBar />
        <SearchPage />
      </ThemeProvider>
    );
  }

  const controllerName = document.body.getAttribute('data-controller');

  if (controllerName === 'directory') {
    import('../bundles/DirectoryBundle')
      .then((DirectoryModule) => {
        const Directory = DirectoryModule.default;

        ReactOnRails.register({ Directory });

        const directoryContainer = document.getElementById('directory-container');

        if (directoryContainer) {
          const directoryRoot = createRoot(directoryContainer);
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
