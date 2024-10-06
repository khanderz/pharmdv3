// application.js
import ReactOnRails from 'react-on-rails';
import NavBar from '../bundles/NavBar/NavBarServer'; // Client-side version
import { createRoot } from 'react-dom/client';


// Register global components like the NavBar
ReactOnRails.register({ NavBar });

// Conditionally load page-specific components or logic
document.addEventListener('DOMContentLoaded', () => {
  const controllerName = document.body.getAttribute('data-controller');
  const actionName = document.body.getAttribute('data-action');

  if (controllerName === 'search' && actionName === 'searchPage') {
    // Dynamically import SearchPage bundle
    import('../bundles/SearchPageBundle')
      .then((SearchPageModule) => {
        const SearchPage = SearchPageModule.default;

        // Register the component explicitly
        ReactOnRails.register({ SearchPage });

        const container = document.getElementById('search-page-container');

        if (container) {
          const root = createRoot(container);
          root.render(<SearchPage />);
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
        ReactOnRails.reactOnRailsPageLoaded(); // Manually trigger
      })
      .catch((error) => {
        console.error('Error loading DirectoryBundle:', error);
      });
  }
});
