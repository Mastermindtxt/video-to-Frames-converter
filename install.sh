#!/bin/bash
set -e

# Variables
PYTHON_VERSION="3.11.6"
PYTHON_INSTALL_DIR="$HOME/python"
FFMPEG_DIR="$HOME/ffmpeg"
FFMPEG_URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-i686-static.tar.xz"

# Function to install Python
install_python() {
    echo "Installing Python $PYTHON_VERSION locally..."
    curl -O https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz
    tar -xf Python-$PYTHON_VERSION.tar.xz
    cd Python-$PYTHON_VERSION
    ./configure --prefix="$PYTHON_INSTALL_DIR"
    make
    make install
    cd ..
    rm -rf Python-$PYTHON_VERSION*
    echo "Python installed in $PYTHON_INSTALL_DIR"
}

# Function to install FFmpeg
install_ffmpeg() {
    echo "Installing FFmpeg locally..."
    curl -L -o ffmpeg-release.tar.xz "$FFMPEG_URL"
    tar -xf ffmpeg-release.tar.xz
    mkdir -p "$FFMPEG_DIR"
    mv ffmpeg-*-static/* "$FFMPEG_DIR"
    rm -rf ffmpeg-*-static ffmpeg-release.tar.xz
    echo "FFmpeg installed in $FFMPEG_DIR"
}

# Update PATH
update_path() {
    echo "Updating PATH..."
    SHELL_CONFIG="$HOME/.bashrc"
    if [ -n "$ZSH_VERSION" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    fi
    {
        echo "export PATH=$PYTHON_INSTALL_DIR/bin:\$PATH"
        echo "export PATH=$FFMPEG_DIR:\$PATH"
    } >> "$SHELL_CONFIG"
    echo "PATH updated. Run 'source $SHELL_CONFIG' to apply changes."
}

# Main
install_python
install_ffmpeg
update_path

echo "Installation complete! Verify with:"
echo "  python3 --version"
echo "  ffmpeg -version"
