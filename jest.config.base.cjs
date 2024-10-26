module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  rootDir: '.', 
  moduleFileExtensions: ['ts', 'js', 'json', 'node'],
  transform: {
    '^.+\\.(t|j)s$': ['ts-jest', { 
      useESM: true,
      diagnostics: false 
    }]
  },
  testMatch: ['**/?(*.)+(spec|test).[tj]s?(x)'],
  collectCoverageFrom: ['**/*.(t|j)s'],
  coverageDirectory: './coverage',
  transformIgnorePatterns: ['node_modules/(?!(YOUR-ESM-MODULE-HERE)/)'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1'
  }
}
