module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  transform: {
    '^.+\\.(ts|tsx)$': 'ts-jest',    // Transforms JavaScript files with Babel for ES modules
  },
  moduleFileExtensions: ['ts', 'tsx', 'js', 'json', 'node'],
  coverageDirectory: '<rootDir>/coverage',
  
  // Only include files in 'src' and exclude non-test and configuration files
  testPathIgnorePatterns: [
    '<rootDir>/node_modules/',
    '<rootDir>/dist/',
    '<rootDir>/coverage/',
    '<rootDir>/jest.config.js',
    '<rootDir>/eslint.config.js',
  ],
  coveragePathIgnorePatterns: [
    '/node_modules/',
    '/dist/',
    '/coverage/',
    '/jest.config.js',
    '/eslint.config.js',
  ],
  
  // Explicitly transform only specified ESM modules in node_modules
  transformIgnorePatterns: [
    '/node_modules/(?!(MODULE_NAME_1|MODULE_NAME_2)/)', // Replace with actual modules needing transformation
  ],

  // Mock non-JS assets
  moduleNameMapper: {
    '\\.(css|scss|sass)$': 'identity-obj-proxy', // Mock CSS imports
    '\\.(jpg|jpeg|png|gif|webp|svg)$': '<rootDir>/__mocks__/fileMock.js', // Mock image imports
  },
}
