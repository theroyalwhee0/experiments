const { globImport } = require("./index");

const modules = globImport('**/goose-*', (_) => _?.isGoose === true);
const moduleCount = Object.keys(modules).length;
console.info(`[INFO ] Matched ${moduleCount} Modules:`, ...Object.keys(modules));
