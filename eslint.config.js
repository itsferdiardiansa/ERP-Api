import js from '@eslint/js';
import typescriptParser from '@typescript-eslint/parser';
import typescriptPlugin from '@typescript-eslint/eslint-plugin';

export default [
  js.configs.recommended,
  {
    files: ['**/*.ts'],
    ignores: ['node_modules/**', 'dist/**'],
    languageOptions: {
      parser: typescriptParser,
      parserOptions: {
        ecmaVersion: 'latest',
        sourceType: 'module',
        project: './tsconfig.json',
        tsconfigRootDir: process.cwd(),
      },
      globals: {
        window: 'readonly',
        document: 'readonly',
        process: 'readonly',
        module: 'readonly',
      },
    },
    plugins: {
      '@typescript-eslint': typescriptPlugin,
    },
    rules: {
      'no-console': 'warn',
      'no-unused-vars': 'warn',
      '@typescript-eslint/no-explicit-any': 'off',
    },
  },
  {
    files: ['*.config.js'],
    languageOptions: {
      globals: {
        module: 'readonly',
        process: 'readonly',
      },
    },
  },
];
