#!/usr/bin/env bash

# Project Structure Initialiser
# Version: 0.0.1
# Purpose: Initialise comprehensive project structures with templates, CI/CD, and documentation

set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
VERSION="0.0.1"

# Configuration
CONFIG_DIR="${HOME}/.config/project-structure-initialiser"
CACHE_DIR="${HOME}/.cache/project-structure-initialiser"
LOG_FILE="${CACHE_DIR}/initialiser.log"

# Default settings
PROJECT_NAME=""
PROJECT_TYPE="generic"
OUTPUT_DIR="."
INIT_GIT=1
CREATE_CI=1
CREATE_DOCS=1
CREATE_TEMPLATES=1
VERBOSE=0
DRY_RUN=0
LICENSE_TYPE="MIT"
AUTHOR_NAME=""
AUTHOR_EMAIL=""

# Project types
PROJECT_TYPES=("generic" "nodejs" "python" "documentation" "research" "data-analysis")

# License types
LICENSE_TYPES=("MIT" "Apache-2.0" "GPL-3.0" "BSD-3-Clause" "ISC" "Unlicense")

# CI/CD providers
CI_PROVIDERS=("github-actions" "gitlab-ci" "jenkins" "none")

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log() {
    local level="$1"
    shift
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$level] $timestamp: $*" | tee -a "$LOG_FILE" >&2
}

info() { log "INFO" "$@"; }
warn() { log "WARN" "$@"; }
error() { log "ERROR" "$@"; exit 1; }
debug() { [[ $VERBOSE -eq 1 ]] && log "DEBUG" "$@" || true; }

# Colored output functions
print_success() { echo -e "${GREEN}$*${NC}"; }
print_info() { echo -e "${BLUE}$*${NC}"; }
print_error() { echo -e "${RED}$*${NC}"; }
print_warning() { echo -e "${YELLOW}$*${NC}"; }

# Help function
show_help() {
    cat << EOF
Project Structure Initializer v${VERSION}

DESCRIPTION:
    Initialize comprehensive project structures with templates, CI/CD pipelines,
    documentation frameworks, and development workflows.

USAGE:
    ${SCRIPT_NAME} [OPTIONS] PROJECT_NAME

OPTIONS:
    -t, --type TYPE          Project type: ${PROJECT_TYPES[*]} [default: generic]
    -o, --output DIR         Output directory [default: current]
    -l, --license TYPE       License type: ${LICENSE_TYPES[*]} [default: MIT]
    -a, --author NAME        Author name
    -e, --email EMAIL        Author email
    --ci PROVIDER           CI/CD provider: ${CI_PROVIDERS[*]} [default: github-actions]
    --no-git                Skip Git repository initialisation
    --no-ci                 Skip CI/CD configuration
    --no-docs               Skip documentation structure
    --no-templates          Skip template creation
    -v, --verbose           Enable verbose output
    -n, --dry-run           Show what would be created without executing
    -h, --help              Show this help message

PROJECT TYPES:
    generic                 General-purpose project structure
    nodejs                  Node.js application with npm configuration
    python                  Python project with pip/poetry setup
    documentation           Documentation-focused project
    research                Research project with data and analysis structure
    data-analysis           Data analysis project with notebooks and datasets

EXAMPLES:
    # Create Node.js project with GitHub Actions
    ${SCRIPT_NAME} -t nodejs -a "John Doe" -e "john@example.com" my-app
    
    # Create documentation project
    ${SCRIPT_NAME} -t documentation --no-ci my-docs
    
    # Create research project with custom license
    ${SCRIPT_NAME} -t research -l "Apache-2.0" research-project
    
    # Dry run to see what would be created
    ${SCRIPT_NAME} -n -t python my-python-app

EOF
}

# Setup directories
setup_dirs() {
    mkdir -p "$CONFIG_DIR" "$CACHE_DIR"
    touch "$LOG_FILE"
}

# Validate project type
validate_project_type() {
    local type="$1"
    
    if [[ ! " ${PROJECT_TYPES[*]} " =~ " ${type} " ]]; then
        error "Invalid project type: $type. Valid types: ${PROJECT_TYPES[*]}"
    fi
}

# Validate license type
validate_license_type() {
    local license="$1"
    
    if [[ ! " ${LICENSE_TYPES[*]} " =~ " ${license} " ]]; then
        error "Invalid license type: $license. Valid licenses: ${LICENSE_TYPES[*]}"
    fi
}

# Get git user information
get_git_user_info() {
    if [[ -z "$AUTHOR_NAME" ]]; then
        AUTHOR_NAME=$(git config --global user.name 2>/dev/null || echo "Your Name")
    fi
    
    if [[ -z "$AUTHOR_EMAIL" ]]; then
        AUTHOR_EMAIL=$(git config --global user.email 2>/dev/null || echo "your.email@example.com")
    fi
}

# Create base directory structure
create_base_structure() {
    local project_dir="$1"
    local project_type="$2"
    
    info "Creating base project structure..."
    
    # Create common directories
    mkdir -p "$project_dir"
    
    case "$project_type" in
        generic)
            mkdir -p "$project_dir/src"
            mkdir -p "$project_dir/tests"
            mkdir -p "$project_dir/docs"
            mkdir -p "$project_dir/scripts"
            mkdir -p "$project_dir/config"
            ;;
        nodejs)
            mkdir -p "$project_dir/src"
            mkdir -p "$project_dir/test"
            mkdir -p "$project_dir/docs"
            mkdir -p "$project_dir/scripts"
            mkdir -p "$project_dir/public"
            mkdir -p "$project_dir/config"
            ;;
        python)
            mkdir -p "$project_dir/src/${PROJECT_NAME//-/_}"
            mkdir -p "$project_dir/tests"
            mkdir -p "$project_dir/docs"
            mkdir -p "$project_dir/scripts"
            mkdir -p "$project_dir/data"
            mkdir -p "$project_dir/notebooks"
            ;;
        documentation)
            mkdir -p "$project_dir/docs/guides"
            mkdir -p "$project_dir/docs/api"
            mkdir -p "$project_dir/docs/tutorials"
            mkdir -p "$project_dir/docs/assets/images"
            mkdir -p "$project_dir/templates"
            mkdir -p "$project_dir/static/css"
            mkdir -p "$project_dir/static/js"
            ;;
        research)
            mkdir -p "$project_dir/data/raw"
            mkdir -p "$project_dir/data/processed"
            mkdir -p "$project_dir/data/external"
            mkdir -p "$project_dir/notebooks"
            mkdir -p "$project_dir/src"
            mkdir -p "$project_dir/reports"
            mkdir -p "$project_dir/references"
            mkdir -p "$project_dir/models"
            ;;
        data-analysis)
            mkdir -p "$project_dir/data/raw"
            mkdir -p "$project_dir/data/processed"
            mkdir -p "$project_dir/data/interim"
            mkdir -p "$project_dir/notebooks/exploratory"
            mkdir -p "$project_dir/notebooks/reports"
            mkdir -p "$project_dir/src/data"
            mkdir -p "$project_dir/src/models"
            mkdir -p "$project_dir/src/visualization"
            mkdir -p "$project_dir/reports/figures"
            ;;
    esac
    
    debug "Created base directory structure for $project_type project"
}

# Create project-specific files
create_project_files() {
    local project_dir="$1"
    local project_type="$2"
    
    info "Creating project-specific files..."
    
    case "$project_type" in
        nodejs)
            create_nodejs_files "$project_dir"
            ;;
        python)
            create_python_files "$project_dir"
            ;;
        documentation)
            create_documentation_files "$project_dir"
            ;;
        research)
            create_research_files "$project_dir"
            ;;
        data-analysis)
            create_data_analysis_files "$project_dir"
            ;;
        generic)
            create_generic_files "$project_dir"
            ;;
    esac
}

# Create Node.js specific files
create_nodejs_files() {
    local project_dir="$1"
    
    # package.json
    cat > "$project_dir/package.json" << EOF
{
  "name": "${PROJECT_NAME}",
  "version": "1.0.0",
  "description": "${PROJECT_NAME} - A Node.js application",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "lint": "eslint src/ test/",
    "lint:fix": "eslint src/ test/ --fix",
    "format": "prettier --write src/ test/",
    "build": "node scripts/build.js"
  },
  "keywords": [
    "nodejs",
    "javascript"
  ],
  "author": "${AUTHOR_NAME} <${AUTHOR_EMAIL}>",
  "license": "${LICENSE_TYPE}",
  "dependencies": {
    "express": "^4.18.2",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {
    "nodemon": "^3.0.1",
    "jest": "^29.7.0",
    "eslint": "^8.57.0",
    "prettier": "^3.2.5",
    "@eslint/js": "^9.0.0"
  },
  "engines": {
    "node": ">=16.0.0",
    "npm": ">=8.0.0"
  }
}
EOF

    # Main application file
    cat > "$project_dir/src/index.js" << 'EOF'
const express = require('express');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.get('/', (req, res) => {
  res.json({
    message: 'Hello World!',
    timestamp: new Date().toISOString(),
    version: process.env.npm_package_version || '1.0.0'
  });
});

app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Something went wrong!',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Internal server error'
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: `Route ${req.originalUrl} not found`
  });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});

module.exports = app;
EOF

    # Environment file
    cat > "$project_dir/.env.example" << 'EOF'
# Application Configuration
NODE_ENV=development
PORT=3000

# Database Configuration
# DATABASE_URL=postgresql://username:password@localhost:5432/database_name

# API Keys
# API_KEY=your_api_key_here

# Other Configuration
# JWT_SECRET=your_jwt_secret_here
EOF

    # ESLint configuration
    cat > "$project_dir/.eslintrc.js" << 'EOF'
module.exports = {
  env: {
    browser: true,
    commonjs: true,
    es2021: true,
    node: true,
    jest: true
  },
  extends: [
    'eslint:recommended'
  ],
  parserOptions: {
    ecmaVersion: 'latest'
  },
  rules: {
    'indent': ['error', 2],
    'linebreak-style': ['error', 'unix'],
    'quotes': ['error', 'single'],
    'semi': ['error', 'always'],
    'no-unused-vars': ['error', { 'argsIgnorePattern': '^_' }],
    'no-console': 'warn'
  }
};
EOF

    # Prettier configuration
    cat > "$project_dir/.prettierrc" << 'EOF'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false
}
EOF

    # Jest configuration
    cat > "$project_dir/jest.config.js" << 'EOF'
module.exports = {
  testEnvironment: 'node',
  collectCoverageFrom: [
    'src/**/*.js',
    '!src/**/*.test.js'
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  testMatch: [
    '**/test/**/*.test.js',
    '**/src/**/*.test.js'
  ]
};
EOF

    # Example test
    cat > "$project_dir/test/app.test.js" << 'EOF'
const request = require('supertest');
const app = require('../src/index');

describe('Application', () => {
  describe('GET /', () => {
    it('should return hello world message', async () => {
      const response = await request(app)
        .get('/')
        .expect(200);
      
      expect(response.body).toHaveProperty('message', 'Hello World!');
      expect(response.body).toHaveProperty('timestamp');
      expect(response.body).toHaveProperty('version');
    });
  });
  
  describe('GET /health', () => {
    it('should return health status', async () => {
      const response = await request(app)
        .get('/health')
        .expect(200);
      
      expect(response.body).toHaveProperty('status', 'OK');
      expect(response.body).toHaveProperty('uptime');
      expect(response.body).toHaveProperty('timestamp');
    });
  });
  
  describe('GET /nonexistent', () => {
    it('should return 404', async () => {
      const response = await request(app)
        .get('/nonexistent')
        .expect(404);
      
      expect(response.body).toHaveProperty('error', 'Not Found');
    });
  });
});
EOF

    debug "Created Node.js project files"
}

# Create Python specific files
create_python_files() {
    local project_dir="$1"
    local package_name="${PROJECT_NAME//-/_}"
    
    # pyproject.toml
    cat > "$project_dir/pyproject.toml" << EOF
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "${PROJECT_NAME}"
version = "0.1.0"
description = "${PROJECT_NAME} - A Python project"
readme = "README.md"
requires-python = ">=3.8"
license = {text = "${LICENSE_TYPE}"}
authors = [
    {name = "${AUTHOR_NAME}", email = "${AUTHOR_EMAIL}"},
]
classifiers = [
    "Development Status :: 3 - Alpha",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.8",
    "Programming Language :: Python :: 3.9",
    "Programming Language :: Python :: 3.10",
    "Programming Language :: Python :: 3.11",
    "Programming Language :: Python :: 3.12",
]
dependencies = [
    "click>=8.0.0",
    "pydantic>=2.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "pytest-cov>=4.0.0",
    "black>=23.0.0",
    "isort>=5.12.0",
    "flake8>=6.0.0",
    "mypy>=1.0.0",
]
test = [
    "pytest>=7.0.0",
    "pytest-cov>=4.0.0",
    "coverage[toml]>=7.0.0",
]

[project.scripts]
${PROJECT_NAME//-/_} = "${package_name}.cli:main"

[project.urls]
Homepage = "https://github.com/yourusername/${PROJECT_NAME}"
Bug-Reports = "https://github.com/yourusername/${PROJECT_NAME}/issues"
Source = "https://github.com/yourusername/${PROJECT_NAME}"

[tool.black]
line-length = 88
target-version = ['py38']

[tool.isort]
profile = "black"
line_length = 88

[tool.mypy]
python_version = "3.8"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true

[tool.pytest.ini_options]
minversion = "7.0"
addopts = "-ra -q --cov=src --cov-report=term-missing --cov-report=html"
testpaths = [
    "tests",
]

[tool.coverage.run]
source = ["src"]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "if self.debug:",
    "if settings.DEBUG",
    "raise AssertionError",
    "raise NotImplementedError",
    "if 0:",
    "if __name__ == .__main__.:",
    "class .*\\bProtocol\\):",
    "@(abc\\.)?abstractmethod",
]
EOF

    # Main package __init__.py
    cat > "$project_dir/src/${package_name}/__init__.py" << EOF
"""${PROJECT_NAME} - A Python project."""

__version__ = "0.1.0"
__author__ = "${AUTHOR_NAME}"
__email__ = "${AUTHOR_EMAIL}"

from .main import main

__all__ = ["main"]
EOF

    # Main module
    cat > "$project_dir/src/${package_name}/main.py" << 'EOF'
"""Main module for the application."""

import logging
from typing import Optional

from pydantic import BaseModel

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Config(BaseModel):
    """Application configuration."""
    
    name: str = "MyApp"
    version: str = "0.1.0"
    debug: bool = False
    log_level: str = "INFO"


class Application:
    """Main application class."""
    
    def __init__(self, config: Optional[Config] = None) -> None:
        """Initialize the application."""
        self.config = config or Config()
        self._setup_logging()
    
    def _setup_logging(self) -> None:
        """Setup application logging."""
        log_level = getattr(logging, self.config.log_level.upper())
        logging.getLogger().setLevel(log_level)
    
    def run(self) -> None:
        """Run the main application logic."""
        logger.info(f"Starting {self.config.name} v{self.config.version}")
        
        # Main application logic here
        self.process_data()
        
        logger.info("Application completed successfully")
    
    def process_data(self) -> dict[str, str]:
        """Process some data (example method)."""
        logger.info("Processing data...")
        
        # Example processing
        result = {
            "status": "success",
            "message": "Data processed successfully",
            "timestamp": "2024-01-01T00:00:00Z"
        }
        
        logger.debug(f"Processing result: {result}")
        return result


def main() -> None:
    """Main entry point."""
    app = Application()
    app.run()


if __name__ == "__main__":
    main()
EOF

    # CLI module
    cat > "$project_dir/src/${package_name}/cli.py" << 'EOF'
"""Command-line interface for the application."""

import logging
from pathlib import Path
from typing import Optional

import click

from .main import Application, Config


@click.group()
@click.option('--verbose', '-v', is_flag=True, help='Enable verbose output')
@click.option('--config', '-c', type=click.Path(exists=True), help='Configuration file path')
@click.pass_context
def cli(ctx: click.Context, verbose: bool, config: Optional[str]) -> None:
    """Application command-line interface."""
    # Setup context
    ctx.ensure_object(dict)
    
    # Configure logging
    log_level = "DEBUG" if verbose else "INFO"
    logging.basicConfig(level=getattr(logging, log_level))
    
    # Load configuration
    app_config = Config(log_level=log_level)
    if config:
        # Load config from file (implement as needed)
        pass
    
    ctx.obj['config'] = app_config


@cli.command()
@click.pass_context
def run(ctx: click.Context) -> None:
    """Run the main application."""
    config = ctx.obj['config']
    app = Application(config)
    app.run()


@cli.command()
@click.option('--output', '-o', type=click.Path(), help='Output file path')
@click.pass_context
def process(ctx: click.Context, output: Optional[str]) -> None:
    """Process data and optionally save to file."""
    config = ctx.obj['config']
    app = Application(config)
    
    result = app.process_data()
    
    if output:
        output_path = Path(output)
        output_path.write_text(str(result))
        click.echo(f"Result saved to {output_path}")
    else:
        click.echo(f"Result: {result}")


@cli.command()
def version() -> None:
    """Show version information."""
    from . import __version__, __author__
    click.echo(f"Version: {__version__}")
    click.echo(f"Author: {__author__}")


def main() -> None:
    """Main CLI entry point."""
    cli()


if __name__ == '__main__':
    main()
EOF

    # Example test
    cat > "$project_dir/tests/test_main.py" << 'EOF'
"""Tests for the main module."""

import pytest

from src.${package_name}.main import Application, Config


class TestConfig:
    """Test the Config class."""
    
    def test_default_config(self):
        """Test default configuration values."""
        config = Config()
        assert config.name == "MyApp"
        assert config.version == "0.1.0"
        assert config.debug is False
        assert config.log_level == "INFO"
    
    def test_custom_config(self):
        """Test custom configuration values."""
        config = Config(
            name="TestApp",
            version="1.0.0",
            debug=True,
            log_level="DEBUG"
        )
        assert config.name == "TestApp"
        assert config.version == "1.0.0"
        assert config.debug is True
        assert config.log_level == "DEBUG"


class TestApplication:
    """Test the Application class."""
    
    def test_application_initialisation(self):
        """Test application initialisation."""
        app = Application()
        assert app.config is not None
        assert isinstance(app.config, Config)
    
    def test_application_with_custom_config(self):
        """Test application with custom configuration."""
        config = Config(name="TestApp")
        app = Application(config)
        assert app.config.name == "TestApp"
    
    def test_process_data(self):
        """Test data processing method."""
        app = Application()
        result = app.process_data()
        
        assert isinstance(result, dict)
        assert "status" in result
        assert "message" in result
        assert "timestamp" in result
        assert result["status"] == "success"
    
    def test_run_method(self):
        """Test the run method doesn't raise exceptions."""
        app = Application()
        # Should not raise any exceptions
        app.run()
EOF

    # requirements.txt for compatibility
    cat > "$project_dir/requirements.txt" << 'EOF'
# This file is for compatibility only
# Use `pip install -e .` or `pip install -e .[dev]` instead
# See pyproject.toml for actual dependencies

-e .
EOF

    debug "Created Python project files"
}

# Create documentation files
create_documentation_files() {
    local project_dir="$1"
    
    # Main documentation index
    cat > "$project_dir/docs/index.md" << EOF
# ${PROJECT_NAME^} Documentation

Welcome to the ${PROJECT_NAME} documentation.

## Table of Contents

- [Getting Started](guides/getting-started.md)
- [User Guide](guides/user-guide.md)
- [API Reference](api/index.md)
- [Tutorials](tutorials/index.md)

## Overview

${PROJECT_NAME} is a comprehensive documentation project that provides...

## Quick Start

1. Clone the repository
2. Install dependencies
3. Build the documentation
4. View the results

## Contributing

See our [contributing guide](guides/contributing.md) for information on how to contribute to this project.
EOF

    # Getting started guide
    cat > "$project_dir/docs/guides/getting-started.md" << EOF
# Getting Started

This guide will help you get started with ${PROJECT_NAME}.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Required software/tools]
- [Additional dependencies]

## Installation

\`\`\`bash
# Installation commands
\`\`\`

## Basic Usage

\`\`\`bash
# Basic usage examples
\`\`\`

## Next Steps

- Read the [User Guide](user-guide.md)
- Explore the [API Reference](../api/index.md)
- Try the [Tutorials](../tutorials/index.md)
EOF

    # API documentation index
    cat > "$project_dir/docs/api/index.md" << EOF
# API Reference

This section contains the API reference documentation for ${PROJECT_NAME}.

## Modules

- [Core Module](core.md)
- [Utilities](utilities.md)
- [Configuration](configuration.md)

## Overview

The API is organised into several modules, each with specific responsibilities:

### Core Module

The core module contains the main functionality...

### Utilities

The utilities module provides helper functions...

### Configuration

The configuration module handles application settings...
EOF

    # Tutorial index
    cat > "$project_dir/docs/tutorials/index.md" << EOF
# Tutorials

Learn how to use ${PROJECT_NAME} with these step-by-step tutorials.

## Beginner Tutorials

- [Tutorial 1: Basic Setup](tutorial-01-basic-setup.md)
- [Tutorial 2: Configuration](tutorial-02-configuration.md)
- [Tutorial 3: Advanced Features](tutorial-03-advanced-features.md)

## Advanced Tutorials

- [Advanced Tutorial 1: Custom Extensions](advanced-01-extensions.md)
- [Advanced Tutorial 2: Integration](advanced-02-integration.md)

## Examples

- [Example 1: Simple Use Case](example-01-simple.md)
- [Example 2: Complex Workflow](example-02-complex.md)
EOF

    # MkDocs configuration
    cat > "$project_dir/mkdocs.yml" << EOF
site_name: ${PROJECT_NAME^} Documentation
site_description: Documentation for ${PROJECT_NAME}
site_author: ${AUTHOR_NAME}
site_url: https://yourusername.github.io/${PROJECT_NAME}/

repo_name: yourusername/${PROJECT_NAME}
repo_url: https://github.com/yourusername/${PROJECT_NAME}
edit_uri: edit/main/docs/

theme:
  name: material
  palette:
    - scheme: default
      primary: blue
      accent: blue
      toggle:
        icon: material/brightness-7
        name: Switch to dark mode
    - scheme: slate
      primary: blue
      accent: blue
      toggle:
        icon: material/brightness-4
        name: Switch to light mode
  features:
    - navigation.tabs
    - navigation.sections
    - navigation.expand
    - navigation.top
    - search.highlight
    - search.suggest
    - content.code.copy

markdown_extensions:
  - admonition
  - codehilite
  - footnotes
  - meta
  - toc:
      permalink: true
  - pymdownx.arithmatex
  - pymdownx.betterem:
      smart_enable: all
  - pymdownx.caret
  - pymdownx.critic
  - pymdownx.details
  - pymdownx.emoji:
      emoji_index: !!python/name:materialx.emoji.twemoji
      emoji_generator: !!python/name:materialx.emoji.to_svg
  - pymdownx.highlight
  - pymdownx.inlinehilite
  - pymdownx.keys
  - pymdownx.magiclink
  - pymdownx.mark
  - pymdownx.smartsymbols
  - pymdownx.superfences
  - pymdownx.tabbed:
      alternate_style: true
  - pymdownx.tasklist:
      custom_checkbox: true
  - pymdownx.tilde

nav:
  - Home: index.md
  - Guides:
    - Getting Started: guides/getting-started.md
    - User Guide: guides/user-guide.md
    - Contributing: guides/contributing.md
  - API Reference:
    - Overview: api/index.md
    - Core: api/core.md
    - Utilities: api/utilities.md
  - Tutorials:
    - Overview: tutorials/index.md
    - Basic Setup: tutorials/tutorial-01-basic-setup.md
    - Configuration: tutorials/tutorial-02-configuration.md

extra:
  social:
    - icon: fontawesome/brands/github
      link: https://github.com/yourusername
    - icon: fontawesome/brands/twitter
      link: https://twitter.com/yourusername

plugins:
  - search
  - git-revision-date-localized:
      type: date
EOF

    debug "Created documentation project files"
}

# Create research project files
create_research_files() {
    local project_dir="$1"
    
    # Research project README
    cat > "$project_dir/README.md" << EOF
# ${PROJECT_NAME^}

A research project investigating [research topic].

## Abstract

[Brief abstract of the research]

## Research Questions

1. [Research question 1]
2. [Research question 2]
3. [Research question 3]

## Methodology

[Description of research methodology]

## Data

- **Raw Data**: Located in \`data/raw/\`
- **Processed Data**: Located in \`data/processed/\`
- **External Data**: Located in \`data/external/\`

## Analysis

Analysis notebooks are located in the \`notebooks/\` directory:

- [01-data-exploration.ipynb](notebooks/01-data-exploration.ipynb)
- [02-data-cleaning.ipynb](notebooks/02-data-cleaning.ipynb)
- [03-analysis.ipynb](notebooks/03-analysis.ipynb)

## Results

Results and reports are available in the \`reports/\` directory.

## Reproducibility

To reproduce this research:

1. Install dependencies: \`pip install -r requirements.txt\`
2. Run notebooks in order
3. Generate reports: \`make reports\`

## Citation

If you use this research, please cite:

\`\`\`
[Citation format]
\`\`\`
EOF

    # Data README
    cat > "$project_dir/data/README.md" << 'EOF'
# Data Directory

This directory contains all data used in the research project.

## Structure

- `raw/`: Original, immutable data dump
- `processed/`: Cleaned and processed data
- `external/`: Data from third-party sources

## Data Sources

| Dataset | Source | Description | License |
|---------|--------|-------------|----------|
| Dataset 1 | [Source] | [Description] | [License] |
| Dataset 2 | [Source] | [Description] | [License] |

## Data Processing

Data processing steps are documented in the notebooks:

1. `01-data-exploration.ipynb`: Initial data exploration
2. `02-data-cleaning.ipynb`: Data cleaning and validation
3. `03-feature-engineering.ipynb`: Feature creation and selection

## Data Dictionary

### Dataset 1

| Column | Type | Description |
|--------|------|-------------|
| id | int | Unique identifier |
| name | str | Item name |
| value | float | Measured value |

## Usage Notes

- All raw data should be treated as read-only
- Processed data can be regenerated from raw data using the notebooks
- External data should be downloaded using the provided scripts
EOF

    # Example notebook
    cat > "$project_dir/notebooks/01-data-exploration.ipynb" << 'EOF'
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# Data Exploration\n",
    "\n",
    "This notebook provides an initial exploration of the research data.\n",
    "\n",
    "## Objectives\n",
    "\n",
    "1. Load and examine the raw data\n",
    "2. Understand data structure and quality\n",
    "3. Identify patterns and anomalies\n",
    "4. Generate summary statistics"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Import libraries\n",
    "import pandas as pd\n",
    "import numpy as np\n",
    "import matplotlib.pyplot as plt\n",
    "import seaborn as sns\n",
    "\n",
    "# Set plotting style\n",
    "plt.style.use('seaborn-v0_8')\n",
    "sns.set_palette('husl')\n",
    "\n",
    "# Display options\n",
    "pd.set_option('display.max_columns', None)\n",
    "pd.set_option('display.max_rows', 100)"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "## Load Data"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Load raw data\n",
    "# df = pd.read_csv('../data/raw/dataset.csv')\n",
    "# print(f'Dataset shape: {df.shape}')\n",
    "# df.head()"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.8.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
EOF

    debug "Created research project files"
}

# Create data analysis files
create_data_analysis_files() {
    local project_dir="$1"
    
    # Data analysis specific setup
    cat > "$project_dir/src/data/make_dataset.py" << 'EOF'
"""Script to download and process raw data."""

import logging
import os
from pathlib import Path

import click


@click.command()
@click.argument('input_filepath', type=click.Path(exists=True))
@click.argument('output_filepath', type=click.Path())
def main(input_filepath: str, output_filepath: str) -> None:
    """Runs data processing scripts to turn raw data from (../raw) into
    cleaned data ready to be analyzed (saved in ../processed).
    """
    logger = logging.getLogger(__name__)
    logger.info('making final data set from raw data')
    
    # Data processing logic here
    logger.info('data processing completed')


if __name__ == '__main__':
    log_fmt = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    logging.basicConfig(level=logging.INFO, format=log_fmt)
    
    # not used in this stub but often useful for finding various files
    project_dir = Path(__file__).resolve().parents[2]
    
    main()
EOF

    debug "Created data analysis project files"
}

# Create generic project files
create_generic_files() {
    local project_dir="$1"
    
    # Simple main file
    cat > "$project_dir/src/main.sh" << 'EOF'
#!/usr/bin/env bash

# Main script for the project

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "Project directory: $PROJECT_DIR"
echo "Script directory: $SCRIPT_DIR"

# Main logic here
echo "Hello from the project!"
EOF

    chmod +x "$project_dir/src/main.sh"
    
    debug "Created generic project files"
}

# Create common files (README, LICENSE, etc.)
create_common_files() {
    local project_dir="$1"
    
    info "Creating common project files..."
    
    # README.md (if not already created)
    if [[ ! -f "$project_dir/README.md" ]]; then
        cat > "$project_dir/README.md" << EOF
# ${PROJECT_NAME^}

${PROJECT_NAME} - A ${PROJECT_TYPE} project

## Description

[Add project description here]

## Installation

[Add installation instructions]

## Usage

[Add usage instructions]

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the ${LICENSE_TYPE} License - see the [LICENSE](LICENSE) file for details.

## Author

${AUTHOR_NAME} <${AUTHOR_EMAIL}>
EOF
    fi
    
    # Create LICENSE file
    create_license_file "$project_dir" "$LICENSE_TYPE"
    
    # .gitignore
    create_gitignore_file "$project_dir" "$PROJECT_TYPE"
    
    debug "Created common project files"
}

# Create LICENSE file
create_license_file() {
    local project_dir="$1"
    local license_type="$2"
    local current_year=$(date +%Y)
    
    case "$license_type" in
        MIT)
            cat > "$project_dir/LICENSE" << EOF
MIT License

Copyright (c) $current_year ${AUTHOR_NAME}

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORES OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
            ;;
        Apache-2.0)
            cat > "$project_dir/LICENSE" << EOF
Apache License
Version 2.0, January 2004
http://www.apache.org/licenses/

[Full Apache 2.0 license text would go here]
EOF
            ;;
        *)
            echo "# License" > "$project_dir/LICENSE"
            echo "This project is licensed under the $license_type license." >> "$project_dir/LICENSE"
            ;;
    esac
}

# Create .gitignore file
create_gitignore_file() {
    local project_dir="$1"
    local project_type="$2"
    
    # Base gitignore
    cat > "$project_dir/.gitignore" << 'EOF'
# IDE and editors
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Build output
dist/
build/
out/
EOF

    # Add project-specific ignores
    case "$project_type" in
        nodejs)
            cat >> "$project_dir/.gitignore" << 'EOF'

# Node.js
node_modules/
coverage/
.nyc_output

# npm
npm-debug.log*
package-lock.json

# Yarn
yarn-debug.log*
yarn-error.log*
yarn.lock
EOF
            ;;
        python)
            cat >> "$project_dir/.gitignore" << 'EOF'

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
PIPFILE.lock

# Virtual environments
venv/
env/
ENV/

# Jupyter Notebook
.ipynb_checkpoints

# pytest
.pytest_cache/
.coverage
htmlcov/

# mypy
.mypy_cache/
.dmypy.json
dmypy.json
EOF
            ;;
        research|data-analysis)
            cat >> "$project_dir/.gitignore" << 'EOF'

# Data files
data/raw/*
data/processed/*
data/external/*
!data/raw/.gitkeep
!data/processed/.gitkeep
!data/external/.gitkeep

# Jupyter Notebook
.ipynb_checkpoints

# Models
models/*.pkl
models/*.h5
models/*.model

# Results
reports/figures/*
!reports/figures/.gitkeep
EOF
            ;;
    esac
}

# Create CI/CD configuration
create_ci_configuration() {
    local project_dir="$1"
    local project_type="$2"
    local ci_provider="$3"
    
    if [[ $CREATE_CI -eq 0 ]]; then
        return 0
    fi
    
    info "Creating CI/CD configuration for $ci_provider..."
    
    case "$ci_provider" in
        github-actions)
            create_github_actions "$project_dir" "$project_type"
            ;;
        gitlab-ci)
            create_gitlab_ci "$project_dir" "$project_type"
            ;;
        jenkins)
            create_jenkinsfile "$project_dir" "$project_type"
            ;;
        none)
            debug "Skipping CI/CD configuration"
            ;;
    esac
}

# Create GitHub Actions workflow
create_github_actions() {
    local project_dir="$1"
    local project_type="$2"
    
    mkdir -p "$project_dir/.github/workflows"
    
    case "$project_type" in
        nodejs)
            cat > "$project_dir/.github/workflows/ci.yml" << 'EOF'
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        node-version: [16.x, 18.x, 20.x]
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v4
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run linter
      run: npm run lint
    
    - name: Run tests
      run: npm run test:coverage
    
    - name: Upload coverage to Codecov
      if: matrix.node-version == '18.x'
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage/lcov.info
EOF
            ;;
        python)
            cat > "$project_dir/.github/workflows/ci.yml" << 'EOF'
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        python-version: ["3.8", "3.9", "3.10", "3.11", "3.12"]
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -e .[dev,test]
    
    - name: Run linter
      run: |
        black --check src tests
        isort --check-only src tests
        flake8 src tests
    
    - name: Run type checker
      run: mypy src
    
    - name: Run tests
      run: pytest
    
    - name: Upload coverage to Codecov
      if: matrix.python-version == '3.11'
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage.xml
EOF
            ;;
        *)
            cat > "$project_dir/.github/workflows/ci.yml" << 'EOF'
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Run tests
      run: |
        echo "Add your test commands here"
        # Example: make test
EOF
            ;;
    esac
    
    debug "Created GitHub Actions workflow"
}

# Create GitLab CI configuration
create_gitlab_ci() {
    local project_dir="$1"
    local project_type="$2"
    
    cat > "$project_dir/.gitlab-ci.yml" << 'EOF'
stages:
  - test
  - build
  - deploy

variables:
  # Add your variables here

test:
  stage: test
  script:
    - echo "Add your test commands here"
  only:
    - main
    - develop
    - merge_requests

build:
  stage: build
  script:
    - echo "Add your build commands here"
  only:
    - main
    - develop

deploy:
  stage: deploy
  script:
    - echo "Add your deployment commands here"
  only:
    - main
EOF
    
    debug "Created GitLab CI configuration"
}

# Create Jenkinsfile
create_jenkinsfile() {
    local project_dir="$1"
    local project_type="$2"
    
    cat > "$project_dir/Jenkinsfile" << 'EOF'
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                // Add your build steps here
            }
        }
        
        stage('Test') {
            steps {
                echo 'Testing...'
                // Add your test steps here
            }
        }
        
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                echo 'Deploying...'
                // Add your deployment steps here
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed'
        }
        success {
            echo 'Pipeline succeeded'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
EOF
    
    debug "Created Jenkinsfile"
}

# Initialize Git repository
init_git_repository() {
    local project_dir="$1"
    
    if [[ $INIT_GIT -eq 0 ]]; then
        return 0
    fi
    
    info "Initializing Git repository..."
    
    cd "$project_dir"
    
    if [[ $DRY_RUN -eq 1 ]]; then
        echo "Would initialise Git repository in: $project_dir"
        return 0
    fi
    
    git init
    git add .
    git commit -m "Initial commit: Project structure created by project-structure-initialiser"
    
    print_info "Git repository initialised with initial commit"
}

# Main project initialisation function
initialise_project() {
    local project_name="$1"
    local project_type="$2"
    local output_dir="$3"
    
    local project_dir="$output_dir/$project_name"
    
    if [[ -d "$project_dir" ]]; then
        error "Project directory already exists: $project_dir"
    fi
    
    print_info "Initializing $project_type project: $project_name"
    print_info "Project directory: $project_dir"
    
    if [[ $DRY_RUN -eq 1 ]]; then
        echo "Would create project structure at: $project_dir"
        echo "Project type: $project_type"
        echo "License: $LICENSE_TYPE"
        echo "Author: $AUTHOR_NAME <$AUTHOR_EMAIL>"
        echo "Git initialisation: $([ $INIT_GIT -eq 1 ] && echo 'Yes' || echo 'No')"
        echo "CI/CD: $([ $CREATE_CI -eq 1 ] && echo 'Yes' || echo 'No')"
        return 0
    fi
    
    # Create project structure
    create_base_structure "$project_dir" "$project_type"
    create_project_files "$project_dir" "$project_type"
    create_common_files "$project_dir"
    create_ci_configuration "$project_dir" "$project_type" "github-actions"
    
    # Initialize Git repository
    init_git_repository "$project_dir"
    
    print_success "Project initialised successfully!"
    print_info "Next steps:"
    echo "  1. cd $project_dir"
    
    case "$project_type" in
        nodejs)
            echo "  2. npm install"
            echo "  3. npm run dev"
            ;;
        python)
            echo "  2. pip install -e .[dev]"
            echo "  3. python -m ${PROJECT_NAME//-/_}.cli --help"
            ;;
        documentation)
            echo "  2. pip install mkdocs-material"
            echo "  3. mkdocs serve"
            ;;
        *)
            echo "  2. Review the generated files"
            echo "  3. Start developing!"
            ;;
    esac
}

# Parse command line arguments
parse_args() {
    CI_PROVIDER="github-actions"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--type)
                PROJECT_TYPE="$2"
                shift 2
                ;;
            -o|--output)
                OUTPUT_DIR="$2"
                shift 2
                ;;
            -l|--license)
                LICENSE_TYPE="$2"
                shift 2
                ;;
            -a|--author)
                AUTHOR_NAME="$2"
                shift 2
                ;;
            -e|--email)
                AUTHOR_EMAIL="$2"
                shift 2
                ;;
            --ci)
                CI_PROVIDER="$2"
                shift 2
                ;;
            --no-git)
                INIT_GIT=0
                shift
                ;;
            --no-ci)
                CREATE_CI=0
                shift
                ;;
            --no-docs)
                CREATE_DOCS=0
                shift
                ;;
            --no-templates)
                CREATE_TEMPLATES=0
                shift
                ;;
            -v|--verbose)
                VERBOSE=1
                shift
                ;;
            -n|--dry-run)
                DRY_RUN=1
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            -*)
                error "Unknown option: $1"
                ;;
            *)
                if [[ -z "$PROJECT_NAME" ]]; then
                    PROJECT_NAME="$1"
                else
                    error "Unexpected argument: $1"
                fi
                shift
                ;;
        esac
    done
    
    if [[ -z "$PROJECT_NAME" ]]; then
        error "Project name is required. Use --help for usage information."
    fi
}

# Main function
main() {
    parse_args "$@"
    
    # Setup environment
    setup_dirs
    
    # Validate inputs
    validate_project_type "$PROJECT_TYPE"
    validate_license_type "$LICENSE_TYPE"
    
    # Get user information
    get_git_user_info
    
    # Initialize project
    initialise_project "$PROJECT_NAME" "$PROJECT_TYPE" "$OUTPUT_DIR"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi