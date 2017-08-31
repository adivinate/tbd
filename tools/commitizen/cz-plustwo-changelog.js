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

const autocomplete = require("inquirer-autocomplete-prompt");
const buildCommit = require("cz-customizable/buildCommit");
const chalk = require("chalk");
const makeDefaultQuestions = require("./make-default-questions");
const autocompleteQuestions = require("./autocomplete-questions");
const Packages = require("../lerna/packages");

const makeSubjectLine = answers => {
  const skipCi = answers.skipCi !== undefined ? answers.skipCi : false;

  return skipCi ? `[skip ci] ${answers.subject}` : answers.subject;
};

const makeAffectsLine = answers => {
  const selectedPackages = answers.packages;

  if (selectedPackages && selectedPackages.length) {
    return `affects: ${selectedPackages.join(", ")}`;
  }

  return null;
};

const mergeQuestions = (defaultQuestions, customQuestions) => {
  const questions = [];
  defaultQuestions.forEach(question => {
    const matchingCustomQuestions = customQuestions.filter(
      ({ name: customQuestionName }) => customQuestionName === question.name
    );
    const customQuestion =
      matchingCustomQuestions.length > 0 && matchingCustomQuestions[0];
    questions.push(customQuestion || question);
  });

  return questions;
};

const makePrompter = (makeCustomQuestions = () => []) => (cz, commit) => {
  const allPackages = Packages.getAllPackages().map(pkg => pkg.name);
  const changedPackages = Packages.getChangedPackages();

  // FIXME: makeDefaultQuestions currently doesn't take any args.
  const defaultQuestions = makeDefaultQuestions(allPackages, changedPackages);
  const customQuestions = makeCustomQuestions(allPackages, changedPackages);
  const questions = mergeQuestions(defaultQuestions, customQuestions);

  // eslint-disable-next-line
  console.log(
    "\n\nLine 1 will be cropped at 100 characters. All other lines will be wrapped after 100 characters.\n"
  );

  cz.registerPrompt("autocomplete", autocomplete);
  cz.prompt(autocompleteQuestions(questions)).then(answers => {
    // eslint-disable-next-line
    answers.subject = makeSubjectLine(answers);

    const affectsLine = makeAffectsLine(answers);
    if (affectsLine) {
      // eslint-disable-next-line
      answers.body = `${affectsLine}\n ${answers.body}`;
    }

    const message = buildCommit(answers);
    /* eslint-disable no-console */
    console.log("\n\nCommit message:");
    console.log(chalk.blue(`\n\n${message}\n`));
    /* eslint-enable no-console */

    commit(message);
  });
};

module.exports = {
  prompter: makePrompter(),
};
