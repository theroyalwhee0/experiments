const path = require('node:path');
const fs = require('node:fs');
const glob = require('glob');

const PACKAGE_JSON = 'package.json';

function globImport(pattern, cb) {
    const modules = {};
    const nodePath = process?.env?.NODE_PATH ?? '';
    const pathPaths = nodePath.split(path.delimiter);
    const searchPaths = [].concat(require.main.paths, pathPaths)
        .filter(_ => !!_);
    for (const searchFolder of searchPaths) {
        const matches = glob.sync(pattern, {
            cwd: searchFolder,
        });
        for (const matchName of matches) {
            const moduleFolder = path.join(searchFolder, matchName);
            const packagePath = path.join(moduleFolder, PACKAGE_JSON);
            try {
                if (!fs.lstatSync(packagePath).isFile()) {
                    continue;
                }
            } catch (err) {
                if (err instanceof Error && err.code === 'ENOENT') {
                    continue;
                }
                throw err;
            }
            const moduleName = path.relative(searchFolder, moduleFolder);
            const loadedModule = require(moduleName);
            let accepted = true;
            if (cb) {
                accepted = cb(loadedModule, {
                    searchFolder,
                    packagePath,
                    moduleName,
                });
            }
            if (accepted) {
                modules[moduleName] = loadedModule;
            }
        }
    }
    return modules;
}

module.exports = {
    globImport,
};
