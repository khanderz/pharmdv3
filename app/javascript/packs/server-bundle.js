import ReactOnRails from "react-on-rails";

import NavBar from "../bundles/NavBar/NavBarServer";
import Directory from "../bundles/DirectoryBundle";
import SearchPage from "../bundles/SearchPageBundle";

ReactOnRails.register({
  NavBar,
  Directory,
  SearchPage,
});
