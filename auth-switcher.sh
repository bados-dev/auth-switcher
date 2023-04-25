#!/bin/bash

CURRENT_DIR="$(pwd)"
COMPOSER_CONFIG_DIR="$(composer config --global home)"
AUTH_SWITCHER_DIR="${HOME}/.auth_switcher"
AUTH_SWITCHER_CONFIG_FILE="${AUTH_SWITCHER_DIR}/config"

# Function to set an editor to edit files with credentials
function editor_settings() {
    if [[ $1 == "" ]]; then
        read -p "Which editor would you like to use to edit files with credentials: " editor
    else
        editor=$1
    fi

    echo "AUTH_EDITOR=${editor}" > "${AUTH_SWITCHER_CONFIG_FILE}"
    echo "Auth switcher will use '${editor}' to edit files with credentials"
}

# Function to check if a file exists or does not exit
function check_file_exist() {
    if [[ $2 == '!' ]]; then
        if [[ ! -f $1 ]]; then
            echo "File '$1' does not exist"
            exit 1
        fi
    else
        if [[ -f $1 ]]; then
            echo "File '$1' exists, please use another name"
            exit 1
        fi
    fi
}

# Checks file name
function check_file_name() {
    if [[ $1 == "" ]]; then
        echo "Please, provide a file name"
        exit 1
    elif [[ ! $1 =~ ^[0-9A-Za-z._-]+$ ]]; then
        echo "Please use only numbers, letters, dashes, dots and underscores in the name"
        exit 1
    fi
}


# Init steps for the first running
[ ! -d "${AUTH_SWITCHER_DIR}" ] && mkdir "${AUTH_SWITCHER_DIR}"

# Loading configuration
if [[ -f "${AUTH_SWITCHER_CONFIG_FILE}" ]]; then
    source "${AUTH_SWITCHER_CONFIG_FILE}"
else
    editor_settings
fi

# Executing the "editor" command
if [[ $1 == "editor" ]]; then
    if [[ $2 == "" ]]; then
        echo "Auth switcher uses the editor: '${AUTH_EDITOR}'"
    else
        editor_settings $2
    fi

# Creating a new file with credentials
elif [[ $1 == "new" ]]; then
    check_file_name $2
    filepath="${AUTH_SWITCHER_DIR}/$2.json"
    check_file_exist $filepath
    touch $filepath
    eval $AUTH_EDITOR $filepath

# Editing a file with credentials
elif [[ $1 == "edit" ]]; then
    check_file_name $2
    filepath="${AUTH_SWITCHER_DIR}/$2.json"
    check_file_exist $filepath '!'
    eval $AUTH_EDITOR $filepath

# Removing a file with credentials
elif [[ $1 == "remove" ]]; then
    check_file_name $2
    filepath="${AUTH_SWITCHER_DIR}/$2.json"
    check_file_exist $filepath '!'
    rm $filepath

# Lising of credential files
elif [[ $1 == "list" ]]; then
    ls "${AUTH_SWITCHER_DIR}"/*.json | xargs -n 1 basename | sed -e 's/\.json$//'

# Copying a file to be used by Composer
elif [[ $1 == "use" ]]; then
    check_file_name $2
    filepath="${AUTH_SWITCHER_DIR}/$2.json"
    check_file_exist $filepath
    
    if [[ $3 == '--global' ]]; then
        auth_file="${COMPOSER_CONFIG_DIR}/auth.json"
    else
        auth_file="${CURRENT_DIR}/auth.json"
    fi

    check_file_exist $filepath

    cp $auth_file $filepath

# Backup creating
elif [[ $1 == "backup" ]]; then
    check_file_name $2
    filepath="${AUTH_SWITCHER_DIR}/$2.json"
    check_file_exist $filepath
    
    if [[ $3 == '--global' ]]; then
        auth_file="${COMPOSER_CONFIG_DIR}/auth.json"
    else
        auth_file="${CURRENT_DIR}/auth.json"
    fi

    check_file_exist $auth_file '!'

    cp $auth_file $filepath
else
    echo '#############################################################'
    echo '# Auth-Switcher                                             #'
    echo '# GitHub repo: https://github.com/BaDos/auth-switcher       #'
    echo '#############################################################'
    echo ''
    echo 'Commands:'
    echo ''
    echo ' * list - provides a list of files with credentials'
    echo ''
    echo ' * editor <editor> - use this command to configure the editor to edit files with credentials'
    echo ''
    echo ' * new <filename> - use this command to create a file with credentials'
    echo ''
    echo ' * edit <filename> - use this command to edit a file with credentials'
    echo ''
    echo ' * remove <filename> - use this command to remove a file with credentials'
    echo ''
    echo ' * use <filename> - use this command to copy a file with credentials to the current directory,'
    echo '   If you use the --global option, a file with credentials will be copied to the Composer config directory, e.g., "use <filename> --global."'
    echo ''
    echo ' * backup - use this command to copy the auth.json file from the current directory to the auth-switcher storage directory,'
    echo '   If you use the --global option, the auth.json file from the Composer config directory will be copied to the auth-switcher storage directory, e.g., "backup --global"'
fi
