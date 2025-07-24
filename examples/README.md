# Project Structure Initialiser Examples

This directory contains usage examples for the Project Structure Initialiser tool. Each example demonstrates a different project type and configuration options.

## Basic Examples

### Generic Project

```bash
./project_structure_initialiser.sh my-generic-project
```

This creates a basic project structure with:
- README.md
- LICENCE file (MIT by default)
- .gitignore
- src/ directory
- docs/ directory
- tests/ directory

### Node.js Project

```bash
./project_structure_initialiser.sh -t nodejs my-node-app
```

Creates a Node.js application with:
- package.json with common scripts
- ESLint and Prettier configuration
- Jest testing setup
- src/ and test/ directories
- GitHub Actions CI configuration

### Python Project with Custom Licence

```bash
./project_structure_initialiser.sh -t python -l "Apache-2.0" my-python-app
```

Creates a Python application with:
- pyproject.toml setup
- Virtual environment configuration
- Apache 2.0 licence instead of the default MIT
- pytest framework
- src/ and tests/ directories

## Advanced Examples

### Research Project with GitLab CI

```bash
./project_structure_initialiser.sh -t research -c gitlab-ci research-project
```

Creates a research project with:
- Data/ directory for datasets
- notebooks/ directory for Jupyter notebooks
- literature/ directory for references
- GitLab CI configuration instead of GitHub Actions

### Documentation Project without Git

```bash
./project_structure_initialiser.sh -t documentation --no-git my-documentation
```

Creates a documentation project without initialising a Git repository:
- docs/ directory with markdown templates
- Table of contents
- No .git/ directory or initial commit

### Data Analysis Project with Custom Output Directory

```bash
./project_structure_initialiser.sh -t data-analysis -o /path/to/projects/ data-analysis-project
```

Creates a data analysis project in a specific directory:
- /path/to/projects/data-analysis-project/
- data/input/ and data/output/ directories
- notebooks/ directory
- visualisation/ directory

### Dry Run Mode

```bash
./project_structure_initialiser.sh -n -t python my-python-app
```

Shows what would be created without making any changes to the filesystem.

## Command Line Options Reference

```
Options:
  -t, --type TYPE          Project type: generic, nodejs, python, documentation, research, data-analysis
  -o, --output DIR         Output directory (default: current directory)
  -l, --license TYPE       Licence type: MIT, Apache-2.0, GPL-3.0, BSD-3-Clause, ISC, Unlicense
  -c, --ci-provider TYPE   CI/CD provider: github-actions, gitlab-ci, jenkins, none
  --no-git                 Skip Git repository initialisation
  --no-ci                  Skip CI/CD configuration generation
  --no-docs                Skip documentation generation
  -n, --dry-run            Show what would be created without making changes
  -v, --verbose            Enable verbose output
  -h, --help               Show this help message
```