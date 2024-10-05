// application.js
import ReactOnRails from 'react-on-rails';
import NavBar from '../bundles/NavBar/NavBarServer'; // Client-side version

// Register global components like the NavBar
ReactOnRails.register({ NavBar });

// Conditionally load page-specific components or logic
document.addEventListener('DOMContentLoaded', () => {
  const controllerName = document.body.getAttribute('data-controller');
  const actionName = document.body.getAttribute('data-action');
console.log({controllerName, actionName});
  if (controllerName === 'search' && actionName === 'searchPage') {
    // Dynamically import SearchPage bundle
    import('../bundles/SearchPageBundle')
      .then((SearchPageModule) => {
        console.log('SearchPageBundle loaded');
        const SearchPage = SearchPageModule.default;
        ReactOnRails.register({ SearchPage });

        ReactOnRails.render("SearchPage", {}, "search-page-container");
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
