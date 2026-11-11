// Prints how many English strings have no Ukrainian translation yet (they fall back to English at runtime).
import { readFileSync } from 'node:fs';

const leafKeys = (value, prefix = '') =>
  value && typeof value === 'object'
    ? Object.entries(value).flatMap(([key, child]) => leafKeys(child, prefix ? `${prefix}.${key}` : key))
    : [prefix];
const keys = file => new Set(leafKeys(JSON.parse(readFileSync(file, 'utf8'))));

const ukrainian = keys('src/locales/uk-UA.json');
console.log([...keys('src/locales/en-US.json')].filter(key => !ukrainian.has(key)).length);
