/*
 * Copyright (c) 2017 Plustwo Inc.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

/* eslint-disable import/no-extraneous-dependencies */

const path = require("path");
const shell = require("shelljs");
const PackageUtilities = require("../../node_modules/lerna/lib/PackageUtilities");
const Repository = require("../../node_modules/lerna/lib/Repository");

/**
 * List all packages, web-clients, etc in this Monorepo.
 */
const getAllPackages = () => {
  /**
   * this is required because lerna will automatically
   * resolve lerna.json path in the root. Here we're
   * forcing lerna to use lerna.json under source/javascript/
   */
  const jsDirectory = path.resolve(__dirname, "../../client/");

  return PackageUtilities.getPackages(new Repository(jsDirectory));
};

/**
 * List all changed packages in Git staged commits.
 */
const getChangedPackages = () => {
  const changedFiles = shell
    .exec("git diff --cached --name-only", { silent: true })
    .stdout.split("\n");

  return getAllPackages()
    .filter(pkg => {
      const packagePrefix = path.relative(".", pkg.location) + path.sep;

      // eslint-disable-next-line
      for (const changedFile of changedFiles) {
        if (changedFile.indexOf(packagePrefix) === 0) {
          return true;
        }
      }

      return false;
    })
    .map(pkg => pkg.name);
};

module.exports = {
  getAllPackages,
  getChangedPackages,
};
