#!/usr/bin/env bash

# remove instances of ****
sed -i '' "s/\*\*\*\*//g" content/_posts/*.markdown

# change instances of "foo: **" to "foo:** "
# note this has a few problems and should be checked afterward for mistakes.
sed -i '' "s/\([A-Z][^$]*\): \*\*/\1:** /g" content/_posts/*.markdown
