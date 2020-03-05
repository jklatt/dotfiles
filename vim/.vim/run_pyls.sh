#!/bin/sh
#
# The only purpose of this file is to run the Python language server
# within a virtual environment, using all supplied arguments. We try
# to be smart about this and detect `poetry` environments.

POETRY_ENV=`poetry env info -p 2> /dev/null | head -n 1`

if [ -z "${POETRY_ENV}" ]; then
  # No environment has been detected; just start the server normally.
  $HOME/.virtualenvs/nvim/bin/python3 -m pyls "$@" 2> ~/.vim/pyls_errors.log
else
  # Use the detected environment and forward it to the server.
  VIRTUAL_ENV=${POETRY_ENV} $HOME/.virtualenvs/nvim/bin/python3 -m pyls "$@" 2> ~/.vim/pyls_errors.log
fi
