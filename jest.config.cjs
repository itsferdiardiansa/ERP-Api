const baseConfig = require('./jest.config.base.cjs')

module.exports = {
  ...baseConfig,
  projects: [
    {
      ...baseConfig,
      displayName: 'apps',
      testMatch: ['<rootDir>/apps/*/src/**/*.spec.ts'],
    },
    {
      ...baseConfig,
      displayName: 'libs',
      testMatch: ['<rootDir>/libs/*/src/**/*.spec.ts'],
    }
  ]
}
