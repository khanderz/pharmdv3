// The source code including full typescript support is available at:
// https://github.com/shakacode/react_on_rails_demo_ssr_hmr/blob/master/config/webpack/development.js

const { devServer, inliningCss } = require('shakapacker');
const webpackConfig = require('./webpackConfig');

const developmentEnvOnly = (clientWebpackConfig, _serverWebpackConfig) => {
  // Enable HMR if it's not already set
  clientWebpackConfig.devServer = {
    ...clientWebpackConfig.devServer,
    hot: true, // Enable Hot Module Replacement
    liveReload: true,
    port: devServer.port || 3035, // Set port
    client: {
      overlay: true, // Show full-screen overlay for errors (moved under client)
    },
  };

  // plugins
  if (inliningCss) {
    const ReactRefreshWebpackPlugin = require('@pmmmwh/react-refresh-webpack-plugin');
    clientWebpackConfig.plugins.push(
      new ReactRefreshWebpackPlugin({
        overlay: {
          sockPort: devServer.port,
        },
      })
    );
  }

  // Ensure Babel is using react-refresh plugin during development
  clientWebpackConfig.module.rules.forEach((rule) => {
    if (rule.use && rule.use.loader === 'babel-loader') {
      rule.use.options.plugins = [
        ...(rule.use.options.plugins || []),
        require.resolve('react-refresh/babel'), // Add react-refresh plugin
      ];
    }
  });
};

module.exports = webpackConfig(developmentEnvOnly);
