// production.js
const webpackConfig = require('./webpack.config');

const productionEnvOnly = (_clientWebpackConfig, _serverWebpackConfig) => {
  // Place production-specific configurations here if necessary
};

module.exports = webpackConfig(productionEnvOnly);
