#!/usr/bin/env bash

echo Checking for hugo installed locally
if ! hugo version
then
  echo Could not find "hugo" command. Hugo must be installed locally. See README.md for detals
  exit 1
fi

echo Starting server on port 1313. Once complete open your browser to http://localhost:1313
open http://localhost:1313

hugo server -w


