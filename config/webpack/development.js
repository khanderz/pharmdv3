const { devServer, inliningCss } = require('shakapacker');
const webpackConfig = require('./webpack.config');
const ReactRefreshWebpackPlugin = require('@pmmmwh/react-refresh-webpack-plugin');

const developmentEnvOnly = (clientWebpackConfig) => {
  clientWebpackConfig.devServer = {
    ...clientWebpackConfig.devServer,
    hot: true,
    liveReload: true,
    port: devServer.port || 3035,
    client: {
      overlay: {
        errors: true, // Show full-screen overlay for errors
        warnings: false, // Optionally disable warnings overlay
      },
    },
    server: {
      type: 'https',
      options: {
        key: '/etc/ssl/certs/server.key', 
        cert: '/etc/ssl/certs/server.crt',
      },
    },
    headers: {
      'Access-Control-Allow-Origin': '*', // Enables CORS
    },
    static: {
      watch: true,
    },
  };

  // Add React Refresh Plugin
  clientWebpackConfig.plugins.push(
    new ReactRefreshWebpackPlugin({
      overlay: {
        sockPort: devServer.port,
      },
    })
  );

  // Exclude node_modules in babel-loader
  clientWebpackConfig.module.rules.forEach((rule) => {
    if (rule.use && rule.use.loader === 'babel-loader') {
      rule.exclude = /node_modules/;
      rule.use.options.plugins = [
        ...(rule.use.options.plugins || []),
        isDevelopmentEnv && require.resolve('react-refresh/babel')
      ].filter(Boolean);
    }
  });
};

module.exports = webpackConfig(developmentEnvOnly);
