// The source code including full typescript support is available at:
// https://github.com/shakacode/react_on_rails_demo_ssr_hmr/blob/master/config/webpack/webpackConfig.js

const clientWebpackConfig = require('./clientWebpackConfig')
const serverWebpackConfig = require('./serverWebpackConfig')
const path = require('path')

const aliasPaths = {
  '@javascript': path.resolve(__dirname, '../../app/javascript/src/'),
  '@components': path.resolve(__dirname, '../../app/javascript/src/components'),
  '@types': path.resolve(__dirname, '../../app/javascript/src/types'),
  // Add more aliases as needed
};

const webpackConfig = (envSpecific) => {
  const clientConfig = clientWebpackConfig()
  const serverConfig = serverWebpackConfig()

  // Add alias for client config
  clientConfig.resolve = {
    ...clientConfig.resolve,
    alias: {
      ...(clientConfig.resolve?.alias || {}),
      ...aliasPaths
    }
  }

  // Add alias for server config (if needed for SSR)
  serverConfig.resolve = {
    ...serverConfig.resolve,
    alias: {
      ...(serverConfig.resolve?.alias || {}),
      ...aliasPaths
    }
  }

  if (envSpecific) {
    envSpecific(clientConfig, serverConfig)
  }

  let result
  // For HMR, need to separate the client and server webpack configurations
  if (process.env.WEBPACK_SERVE || process.env.CLIENT_BUNDLE_ONLY) {
    // eslint-disable-next-line no-console
    console.log('[React on Rails] Creating only the client bundles.')
    result = clientConfig
  } else if (process.env.SERVER_BUNDLE_ONLY) {
    // eslint-disable-next-line no-console
    console.log('[React on Rails] Creating only the server bundle.')
    result = serverConfig
  } else {
    // default is the standard client and server build
    // eslint-disable-next-line no-console
    console.log('[React on Rails] Creating both client and server bundles.')
    result = [clientConfig, serverConfig]
  }

  // To debug, uncomment next line and inspect "result"
  // debugger
  return result
}

module.exports = webpackConfig
