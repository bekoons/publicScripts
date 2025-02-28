#!/bin/sh
# Script for setting up a new python virtual environment for use when a specific version of python is required.
# Defaults to Python3 versions.
# Assumes you have already installed the version of python you want to use within pyenv using 'pyenv install -v $version'

DirectoryName=''
Python3Version=''

print_usage() {
  printf '    Usage: ./new_python3VirtualEnv.sh [Create, Delete] DirectoryPath Python3Version\n'
  printf '    E.g. ./new_python3VirtualEnv.sh Create ~/Scripts/Project1 3.11.1\n'
  exit 1
}

PyenvMode=$(sed "s/ //g" <<< $1)
VirtualEnvPath=$(sed "s/ //g" <<< $2)
Python3Version=$(sed "s/ //g" <<< $3)

# Check if the specified Python version is installed in pyenv
if ! pyenv versions --bare | grep -q "^${Python3Version}$"; then
  echo "\n    The specified Python version ${Python3Version} is not installed in pyenv."
  echo "    Please install it using 'pyenv install -v ${Python3Version}' before running this script.\n"
  exit 1
fi

if [[ $PyenvMode == "delete" ]]
then
    if [ $# -ne 2 ]
    then
        echo "\n    Wrong number of arguments detected, refer to usage instructions below.\n"
        print_usage;
    fi

    echo "    Deleting VirtualEnv $VirtualEnvPath... Note that this does not delete the directory or files contained within, just removes the virtual python environment.\n"
    pyenv virtualenv-delete $VirtualEnvPath
elif [[ $PyenvMode == "create" ]]
then
    if [[ $# -ne 3 ]]
    then
        echo "\n    Wrong number of arguments detected, refer to usage instructions below.\n"
        print_usage;
    fi

    if [[ -d "$VirtualEnvPath" ]]
    then
        echo "    $VirtualEnvPath directory exists already. Please check to see if a python3 virtual environment has already been created for this directory. Exiting..."
        exit 1
    else
        echo "    Creating $VirtualEnvPath virtualenv."
    fi

    mkdir $VirtualEnvPath

    cd $VirtualEnvPath
    VirtualEnvName=$(basename "$VirtualEnvPath")
    echo "venv name: $VirtualEnvName"

    pyenv virtualenv $Python3Version $VirtualEnvName
    pyenv local $VirtualEnvName

    pyenv versions

    echo "   Finished directory and initializing pyenv. Check output of 'pyenv versions' command to verify that there is an asterisk next to the virtualenv directory name.\n"
else
    echo "\n    Invalid command mode, refer to usage instructions below.\n"
    print_usage;
fi
