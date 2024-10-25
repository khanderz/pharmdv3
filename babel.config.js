// babel.config.js

module.exports = function (api) {
  const defaultConfigFunc = require("shakapacker/package/babel/preset.js");
  const resultConfig = defaultConfigFunc(api);
  const isDevelopmentEnv = api.env("development");
  const isProductionEnv = api.env("production");

  const changesOnDefault = {
    presets: [
      [
        "@babel/preset-react",
        {
          development: isDevelopmentEnv,
          useBuiltIns: true,
        },
      ],
    ],
    plugins: [
      // Apply react-refresh plugin only in development
      isDevelopmentEnv && require.resolve("react-refresh/babel"),
      // Strip prop-types in production to reduce bundle size
      isProductionEnv && [
        "babel-plugin-transform-react-remove-prop-types",
        {
          removeImport: true,
        },
      ],
    ].filter(Boolean),
  };

  // Merge additional presets and plugins with the default Shakapacker presets
  resultConfig.presets = [...resultConfig.presets, ...changesOnDefault.presets];
  resultConfig.plugins = [...resultConfig.plugins, ...changesOnDefault.plugins];

  return resultConfig;
};
