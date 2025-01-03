#!/bin/bash
set -e

# Display a banner
banner() {
    echo -e "\033[1;32m"  # Set text color to green and bold
    echo "#############################################################"
    echo "#                                                           #"
    echo "#                    WELCOME TO MASTERMIND                 #"
    echo "#                Python & FFmpeg Installer                 #"
    echo "#                                                           #"
    echo "#############################################################"
    echo -e "\033[0m"  # Reset text formatting
}

# Variables
PYTHON_VERSION="3.11.6"
PYTHON_INSTALL_DIR="$HOME/python"
FFMPEG_DIR="$HOME/ffmpeg"
FFMPEG_URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-i686-static.tar.xz"

# Install Python
install_python() {
    echo -e "\033[1;34mInstalling Python $PYTHON_VERSION locally...\033[0m"
    curl -O https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz
    tar -xf Python-$PYTHON_VERSION.tar.xz
    cd Python-$PYTHON_VERSION
    ./configure --prefix="$PYTHON_INSTALL_DIR"
    make
    make install
    cd ..
    rm -rf Python-$PYTHON_VERSION*
    echo -e "\033[1;32mPython installed successfully in $PYTHON_INSTALL_DIR\033[0m"
}

# Install FFmpeg
install_ffmpeg() {
    echo -e "\033[1;34mInstalling FFmpeg locally...\033[0m"
    curl -L -o ffmpeg-release.tar.xz "$FFMPEG_URL"
    tar -xf ffmpeg-release.tar.xz
    mkdir -p "$FFMPEG_DIR"
    mv ffmpeg-*-static/* "$FFMPEG_DIR"
    rm -rf ffmpeg-*-static ffmpeg-release.tar.xz
    echo -e "\033[1;32mFFmpeg installed successfully in $FFMPEG_DIR\033[0m"
}

# Update PATH
update_path() {
    echo -e "\033[1;34mUpdating PATH...\033[0m"
    SHELL_CONFIG="$HOME/.bashrc"
    if [ -n "$ZSH_VERSION" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    fi
    {
        echo "export PATH=$PYTHON_INSTALL_DIR/bin:\$PATH"
        echo "export PATH=$FFMPEG_DIR:\$PATH"
    } >> "$SHELL_CONFIG"
    echo -e "\033[1;32mPATH updated. Run 'source $SHELL_CONFIG' to apply changes.\033[0m"
}

# Main
banner
install_python
install_ffmpeg
update_path

echo -e "\033[1;33mInstallation complete! Verify installations:\033[0m"
echo -e "  \033[1;36mpython3 --version\033[0m"
echo -e "  \033[1;36mffmpeg -version\033[0m"
