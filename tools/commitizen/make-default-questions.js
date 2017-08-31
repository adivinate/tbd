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

const inquirer = require("inquirer");

module.exports = () => [
  {
    type: "autocomplete",
    name: "type",
    message: 'Select the type of change that you"re committing:',
    choices: [
      {
        value: "feat",
        name: "feat: A new feature",
      },
      {
        value: "fix",
        name: "fix: A bug fix",
      },
      {
        value: "docs",
        name: "docs: Documentation only changes",
      },
      {
        value: "style",
        name:
          "style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)",
      },
      {
        value: "refactor",
        name:
          "refactor: A code change that neither fixes a bug nor adds a feature",
      },
      {
        value: "perf",
        name: "perf: A code change that improves performance",
      },
      {
        value: "test",
        name: "test: Adding missing tests or correcting existing tests",
      },
      {
        value: "build",
        name:
          "build: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)",
      },
      {
        value: "ci",
        name:
          "ci: Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)",
      },
      {
        value: "chore",
        name: "chore: Other changes that don't modify src or test files",
      },
      {
        value: "revert",
        name: "revert: Revert to a commit",
      },
      {
        value: "WIP",
        name: "WIP: Work in progress",
      },
    ],
  },
  {
    type: "confirm",
    name: "skipCi",
    message: "Should this commit skip CI?",
    default: true,
    when: answers => ["docs"].indexOf(answers.type) >= 0,
  },
  {
    type: "input",
    name: "scope",
    message: "Denote the scope of this change (eg. domain, license): ",
    validate: value => !!value,
  },
  {
    type: "input",
    name: "subject",
    message: "Write a short, imperative tense description of the change:\n",
    filter: value => value.charAt(0).toLowerCase() + value.slice(1),
    validate: value => !!value,
  },
  {
    type: "input",
    name: "body",
    message:
      "Provide a longer description of the change (optional). Use '|' to break new line:\n",
  },
  {
    type: "input",
    name: "breaking",
    message: "List any BREAKING CHANGES (if none, leave blank):\n",
  },
  {
    type: "input",
    name: "footer",
    message:
      "List any ISSUES CLOSED by this change (optional). E.g.: #31, #34:\n",
  },
];
