#!/usr/bin/env node
// The v3 examples' parse gate: every v3-* example package loads and
// checks CLEAN through the kernel checkout the parity job provides
// (critique §40: the examples were never machine-checked). Fictional
// content only (the examples README's rule).
import { readdirSync, existsSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const TS = process.env.PRIMMEL_TS_ROOT ?? join(dirname(ROOT), 'primmel-ts');

const { checkPackage } = await import(
  join(TS, 'packages', 'primmel', 'src', 'check.ts')
);

const examples = readdirSync(join(ROOT, 'examples')).filter(e =>
  /^v3-/.test(e),
);
if (examples.length === 0) {
  console.error('check-v3-examples: no v3-* examples found');
  process.exit(2);
}
let bad = 0;
for (const e of examples.sort()) {
  const dir = join(ROOT, 'examples', e);
  if (!existsSync(join(dir, 'package.primmel'))) {
    continue;
  }
  const errors = checkPackage(dir).filter(i => i.severity === 'error');
  if (errors.length === 0) {
    console.log(`  ✓ ${e}: loads and checks clean`);
  } else {
    bad += 1;
    console.error(`✗ ${e}: ${errors.length} error(s)`);
    for (const i of errors) {
      console.error(`    ${i.check}: ${i.message.slice(0, 100)}`);
    }
  }
}
console.log(
  bad === 0
    ? `v3 examples: ${examples.length} package(s), all clean`
    : `v3 examples: ${bad} of ${examples.length} failing`,
);
process.exit(bad === 0 ? 0 : 1);
