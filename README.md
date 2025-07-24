# Project Structure Initialiser

![ShellCheck](https://github.com/warwickbrownteya/project-structure-initialiser/actions/workflows/shellcheck.yml/badge.svg)
![License: Proprietary](https://img.shields.io/badge/License-Proprietary-red.svg)

A command-line tool that generates standardised project structures with appropriate templates, CI/CD configurations, and documentation.

## Features

- **Multi-language Templates**: For Node.js, Python, and other languages
- **CI/CD Integration**: Configuration for GitHub Actions, GitLab CI, and Jenkins
- **Documentation Templates**: README files, contributing guidelines, and more
- **Best Practices**: Standard project layouts for each project type
- **Configurable Templates**: Adaptable project structures
- **Licence Management**: Templates for various licence types
- **Git Integration**: Automatic repository initialisation

## Requirements

- Bash 4.0 or later
- Git (optional, for repository initialisation)

## Installation

### Option 1: Using the installer script

```bash
# Clone the repository
git clone https://github.com/warwickbrownteya/project-structure-initialiser.git
cd project-structure-initialiser

# Run the installer
./install.sh
```

### Option 2: Manual installation

```bash
# Clone the repository
git clone https://github.com/warwickbrownteya/project-structure-initialiser.git

# Make the script executable
chmod +x project-structure-initialiser.sh

# Optional: Create a symbolic link to make it available system-wide
sudo ln -s "$(pwd)/project-structure-initialiser.sh" /usr/local/bin/project-structure-initialiser
```

## Usage

```bash
project-structure-initialiser.sh [options] project_name
```

### Basic Examples

```bash
# Create a generic project
project-structure-initialiser.sh my-project

# Create a Node.js project
project-structure-initialiser.sh -t nodejs my-node-app

# Create a Python project with MIT licence (overriding the proprietary default)
project-structure-initialiser.sh -t python -l "MIT" my-python-app

# Create a documentation project without initialising Git
project-structure-initialiser.sh -t documentation --no-git my-docs
```

### Available Options

```
Options:
  -t, --type TYPE          Project type: generic, nodejs, python, documentation, research, data-analysis [default: generic]
  -o, --output DIR         Output directory [default: current]
  -l, --license TYPE       Licence type: Proprietary, MIT, Apache-2.0, GPL-3.0, BSD-3-Clause, ISC, Unlicense [default: Proprietary]
  -a, --author NAME        Author name
  -e, --email EMAIL        Author email
  --no-templates          Skip template creation
  --ci PROVIDER           CI/CD provider: github-actions, gitlab-ci, jenkins, none [default: github-actions]
  --no-git                 Skip Git repository initialisation
  --no-ci                 Skip CI/CD configuration
  --no-docs               Skip documentation structure
  -n, --dry-run           Show what would be created without executing
  -v, --verbose           Enable verbose output
  -h, --help              Show this help message
```

## Project Types

The tool supports several project types, each with its own specialised structure:

### Generic Project
Basic project layout with minimal structure, suitable as a starting point for any project.

### Node.js Project
Structure for Node.js applications, including:
- package.json with common scripts
- ESLint and Prettier configurations
- Jest testing setup
- src and test directories
- CI/CD pipeline for Node.js

### Python Project
Structure for Python applications, including:
- pyproject.toml setup
- Virtual environment configuration
- pytest framework
- src and tests directories
- CI/CD pipeline for Python

### Documentation Project
Structure focused on documentation, including:
- Markdown templates
- Documentation generation configuration
- Table of contents
- Contributing guidelines

### Research Project
Structure for research-oriented projects, including:
- Data directories
- Notebook setup
- Literature references
- Experiment tracking

### Data Analysis Project
Structure for data analysis projects, including:
- Data input/output directories
- Notebook configuration
- Visualisation templates
- Analysis workflow

## Configuration

The tool stores its configuration in these locations:

- **Config directory**: `~/.config/project-structure-initialiser`
- **Cache directory**: `~/.cache/project-structure-initialiser`
- **Log file**: `~/.cache/project-structure-initialiser/initialiser.log`

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Licence

This project is proprietary software with no distribution rights. For internal use only - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- Inspired by various project scaffolding tools and project setup experience
- Thanks to all contributors