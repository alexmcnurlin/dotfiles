#! /usr/bin/env python

import os
import re
import sys


def find(text, step_directory="steps/", default_filename=None):
    try:
        old_dir = os.getcwd()
        os.chdir(step_directory)
    except OSError:
        print("Could not find directory {}".format(step_directory))
        raise

    try:
        sm = SearchManager(text)
        matches = sm.search_all()
    finally:
        os.chdir(old_dir)

    return matches


class SearchManager():
    def __init__(self, step_string):
        raw_text = step_string.strip()
        split_text = raw_text.split(' ', 1)
        self.step_string = split_text[1]
        self.step_type = split_text[0]
        self.regex = re.compile(r"@(?P<type>step|given|when|then)\([\'\"](?P<regex>.*?)[\'\"]\)", re.MULTILINE | re.DOTALL)
        self.results = []

    def search(self, filename):
        with open(filename) as f:
            file_text = "".join(f.readlines())
        matches = self.regex.finditer(file_text)
        substitution = re.compile(r"[\'\"]\n\s*[\'\"]",  flags=re.MULTILINE | re.DOTALL)
        results = []
        for match in matches:
            step_type, raw_text = match.groups()
            text = substitution.sub("", raw_text)
            if re.match("^{}$".format(text), self.step_string):
                results.append((os.path.abspath(filename), match.start(), match.end()))
        return results

    def search_all(self):
        files = [file for file in os.listdir()
                 if os.path.isfile(file)]
        results = []
        for file in files:
            newlist = self.search(file)
            if newlist:
                results += newlist
        return [x for x in results if x is not None]


if __name__ == '__main__':
    assert len(sys.argv) in (2, 3), "Invalid number of arguments"
    results = find(*sys.argv[1:])
    [print(x[0]) for x in results]
