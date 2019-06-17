module.exports = {
  env: {
    node: true,
    es6: true
  },
  extends: [
    'eslint:recommended',
    'plugin:prettier/recommended'
  ],
  plugins: [
    '@typescript-eslint'
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    'sourceType': 'module',
    'project': './tsconfig.json',
    'ecmaVersion': 2019
  },
  rules: {
    'no-console': 0,
    'no-unused-vars': 0
  },
  settings: {
    node: {
      tryExtensions: ['.ts', '.tsx', '.js', '.jsx', '.json', '.node']
    }
  }
};
