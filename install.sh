#!/bin/bash

CURRENT_OS=$(uname)
USERNAME=""
DOTFILES=(.vim .vimrc .gitconfig .tmux.conf .tmux_snapshot.conf .bashrc
.bash_profile .aliases .exports .utilities .inputrc)
MAKE_BACKUPS=true

if [[ "${CURRENT_OS}" == "Darwin" ]]; then
    HOME_PREFIX=/Users
else
    HOME_PREFIX=/home
fi

usage() {
cat << EOF
Usage: $0 -u username

Available options:
    -c perform a "clean" installation, i.e. don't make any backups of existing
    files prior to deleting them
    -h shows this help text
EOF
    exit 1
}

remove_initial() {
    echo "Removing initial files..."

    # loop through the list of dotfiles. Backup
    # the existing ones and remove them
    for dotfile in "${DOTFILES[@]}"
    do
        local filename="${HOME}"/"${dotfile}"
        if [ -f "${filename}" ] || [ -d "${filename}" ]; then
            if [ "${MAKE_BACKUPS}" = true ]; then
                local backup_path="${filename}.bak"

                # make a backup of the existing file
                echo "${filename} exists, saving a backup to: ${backup_path}"
                cat "${filename}" > "${backup_path}"
            fi
            
            # delete the existing dotfile
            rm -rfv "${filename}"
        fi
    done
}

link_dotfiles() {
    # create some directories if necessary
    local dirs=("${DOTFILES_DIR}/vim/backup" "${DOTFILES_DIR}/vim/swap" "${HOME}/.config/nvim")
    
    for dir in "${dirs[@]}"
    do
        if [ ! -d "${dir}" ]; then
            echo "${dir} doesn't exist, creating..."
            mkdir -pv "${dir}"
        fi
    done

    echo "Linking dotfiles..."
    # Create the symlinks

    # ...for vim
    ln -sfv "${DOTFILES_DIR}"/vim "${HOME_DIR}"/.vim
    ln -sfv "${DOTFILES_DIR}"/vim/vimrc "${HOME_DIR}"/.vimrc
    # ...for nvim
    ln -sfv "${DOTFILES_DIR}"/vim/init.vim "${HOME_DIR}"/.config/nvim/init.vim
    # ...for git
    ln -sfv "${DOTFILES_DIR}"/git/gitconfig "${HOME_DIR}"/.gitconfig
    # ...for tmux
    ln -sfv "${DOTFILES_DIR}"/tmux/tmux.conf "${HOME_DIR}"/.tmux.conf
    ln -sfv "${DOTFILES_DIR}"/tmux/tmux_snapshot.conf "${HOME_DIR}"/.tmux_snapshot.conf
    # ...for bash
    ln -sfv "${DOTFILES_DIR}"/bash/bash_profile "${HOME_DIR}"/.bash_profile
    ln -sfv "${DOTFILES_DIR}"/bash/bashrc "${HOME_DIR}"/.bashrc
    ln -sfv "${DOTFILES_DIR}"/bash/aliases "${HOME_DIR}"/.aliases
    ln -sfv "${DOTFILES_DIR}"/bash/exports "${HOME_DIR}"/.exports
    ln -sfv "${DOTFILES_DIR}"/bash/utilities "${HOME_DIR}"/.utilities
    ln -sfv "${DOTFILES_DIR}"/bash/inputrc "${HOME_DIR}"/.inputrc
}

# Chown the dotfiles
chown_dotfiles() {
    echo "chown'ing dotfiles..."
    chown -R "${USERNAME}":"${GROUP}" "${DOTFILES_DIR}"
    for dotfile in "${DOTFILES[@]}"
    do
        chown -R "${USERNAME}":"${GROUP}" "${HOME_DIR}"/"${dotfile}"
    done
}

setup_vim() {
    echo "Setting up vim..."

    if [ -f ${HOME}/.vim/autoload/plug.vim ]; then
        echo "vim-plug already installed, upgrading..."
    else
        echo "Installing vim-plug..."
    fi

    curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    echo "Installing vim plugins..."
    nvim -es -u ${HOME}/.config/nvim/init.vim -i NONE -c "PlugInstall" -c "qa"

    # See https://github.com/neoclide/coc-snippets/issues/196#issuecomment-781231190
    echo "Upgrading pynvim..."
    python3 -m pip install --user --upgrade pynvim
}

setup_coc() {
    # See https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim

    # Install extensions
    echo "Installing coc extensions..."
    mkdir -p ${HOME}/.config/coc/extensions
    cd ${HOME}/.config/coc/extensions
    if [ ! -f package.json ]; then
        echo '{"dependencies":{}}' > package.json
    fi

    npm install coc-phpls coc-tsserver coc-html coc-snippets --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
    cd -
}

while getopts ":hu:c" opt; do
    case "${opt}" in
        h)
            usage
            ;;
        u)
            USERNAME="${OPTARG}"
            HOME_DIR="${HOME_PREFIX}"/"${USERNAME}"
            DOTFILES_DIR="${HOME_DIR}"/.dotfiles

            if [[ "${CURRENT_OS}" == "Darwin" ]]; then
                GROUP=staff
            else
                GROUP="${USERNAME}"
            fi
            ;;
        c)
            MAKE_BACKUPS=false
            ;;
        *) 
            usage 
            ;;
    esac
done

# Check whether all vars have been set correctly

if [[ ! -d "${HOME_DIR}" ]]; then
    if [[ "${USERNAME}" == "" ]]; then
        echo "You must provide a username."
    else
        echo "The user \"${USERNAME}\" doesn't exist."
    fi
    usage
fi

echo "User: ${USERNAME}"
echo "Group: ${GROUP}"

remove_initial
link_dotfiles
chown_dotfiles
setup_vim
setup_coc

echo "Installation finished!"
