import ReactOnRails from 'react-on-rails';
import NavBar from '../bundles/NavBar/NavBarServer'; // Client-side version
import { createRoot } from 'react-dom/client';
import { ThemeProvider } from '@mui/material/styles';
import theme from '../design-system/theme';

ReactOnRails.register({ NavBar });

document.addEventListener('DOMContentLoaded', () => {
  const controllerName = document.body.getAttribute('data-controller');
  const actionName = document.body.getAttribute('data-action');

  if (controllerName === 'search' && actionName === 'searchPage') {
    import('../bundles/SearchPageBundle')
      .then((SearchPageModule) => {
        const SearchPage = SearchPageModule.default;

        ReactOnRails.register({ SearchPage });

        const container = document.getElementById('search-page-container');

        if (container) {
          const root = createRoot(container);

          // Wrap the component with ThemeProvider
          root.render(
            <ThemeProvider theme={theme}>
              <SearchPage />
            </ThemeProvider>
          );
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

        ReactOnRails.reactOnRailsPageLoaded();
      })
      .catch((error) => {
        console.error('Error loading DirectoryBundle:', error);
      });
  }
});
