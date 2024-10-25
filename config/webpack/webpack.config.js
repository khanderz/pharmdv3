const CircularDependencyPlugin = require('circular-dependency-plugin');
const { env, generateWebpackConfig, merge } = require('shakapacker');
const { existsSync } = require('fs');
const { resolve } = require('path');
const clientWebpackConfig = require('./clientWebpackConfig');
const serverWebpackConfig = require('./serverWebpackConfig');
const WebpackAssetsManifest = require('webpack-assets-manifest');

const envSpecificConfig = () => {
  const path = resolve(__dirname, `${env.nodeEnv}.js`);
  if (existsSync(path)) {
    return require(path);
  } else {
    throw new Error(`Could not find file ${path} for NODE_ENV`);
  }
};

const customConfig = {
  output: {
    publicPath: 'auto',
  },
  plugins: [
    new WebpackAssetsManifest({
      output: env.nodeEnv === 'production' ? 'manifest.production.json' : 'manifest.development.json',
      merge: true,
      writeToDisk: env.nodeEnv === 'production',
    }),
    new CircularDependencyPlugin({
      // Exclude detection in node_modules
      exclude: /node_modules/,
      // Show warnings rather than fail the build
      failOnError: false,
      // Log each detected circular dependency to console
      onDetected({ module: webpackModuleRecord, paths, compilation }) {
        compilation.warnings.push(new Error(paths.join(' -> ')));
      },
    }),
  ],
  resolve: {
    alias: {
      '@javascript': resolve(__dirname, '../../app/javascript/src/'),
      '@components': resolve(__dirname, '../../app/javascript/src/components'),
      '@types': resolve(__dirname, '../../app/javascript/src/types'),
    },
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx|ts|tsx)$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            plugins: [
              env.nodeEnv === 'development' && require.resolve('react-refresh/babel'),
            ].filter(Boolean),
          },
        },
      },
    ],
  },
};

const webpackConfig = (envSpecific) => {
  const clientConfig = merge(clientWebpackConfig(), customConfig, envSpecificConfig());
  const serverConfig = merge(serverWebpackConfig(), customConfig, envSpecificConfig());
  return generateWebpackConfig(process.env.SERVER_BUNDLE_ONLY ? serverConfig : clientConfig);
};

module.exports = webpackConfig;
