const baseConfig = require('./jest.config.base.cjs')

module.exports = {
  ...baseConfig,
  projects: [
    '<rootDir>/apps/auth-service'
  ]
}
