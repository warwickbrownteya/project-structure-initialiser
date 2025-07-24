#!/usr/bin/env bash

# Project Structure Initialiser Installer
# This script installs the Project Structure Initialiser tool to your system

set -euo pipefail

# Configuration
SCRIPT_NAME="project_structure_initialiser.sh"
INSTALL_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.config/project-structure-initialiser"
CACHE_DIR="${HOME}/.cache/project-structure-initialiser"

# Colours for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Colour

# Logging functions
info() { echo -e "${BLUE}INFO:${NC} $*"; }
success() { echo -e "${GREEN}SUCCESS:${NC} $*"; }
warn() { echo -e "${YELLOW}WARNING:${NC} $*"; }
error() { echo -e "${RED}ERROR:${NC} $*"; exit 1; }

# Check if script is run with root privileges
if [ "$(id -u)" -eq 0 ]; then
    warn "Running as root is not recommended. Consider installing as a regular user."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Create directories
create_directories() {
    info "Creating required directories..."
    mkdir -p "${INSTALL_DIR}" "${CONFIG_DIR}" "${CACHE_DIR}"
    
    if [[ ! ":$PATH:" == *":${INSTALL_DIR}:"* ]]; then
        warn "${INSTALL_DIR} is not in your PATH. You may need to add it."
        echo "Add the following line to your shell configuration file (.bashrc, .zshrc, etc.):"
        echo "export PATH=\"\$PATH:${INSTALL_DIR}\""
    fi
}

# Install the script
install_script() {
    info "Installing Project Structure Initialiser..."
    
    # Check if script exists in current directory
    if [[ ! -f "${SCRIPT_NAME}" ]]; then
        error "Cannot find ${SCRIPT_NAME} in the current directory"
    fi
    
    # Copy the script to install directory
    cp "${SCRIPT_NAME}" "${INSTALL_DIR}/"
    chmod +x "${INSTALL_DIR}/${SCRIPT_NAME}"
    
    # Create a symbolic link without the extension for easier access
    ln -sf "${INSTALL_DIR}/${SCRIPT_NAME}" "${INSTALL_DIR}/project-structure-initialiser"
    
    success "Installation completed successfully"
    echo "You can now run the tool using:"
    echo "  project-structure-initialiser [options] project_name"
    echo "  or"
    echo "  ${SCRIPT_NAME} [options] project_name"
}

# Main function
main() {
    echo "Project Structure Initialiser - Installer"
    echo "========================================"
    
    create_directories
    install_script
    
    echo
    echo "For documentation and usage examples, visit:"
    echo "https://github.com/warwickbrownteya/project-structure-initialiser"
}

# Run the installer
main