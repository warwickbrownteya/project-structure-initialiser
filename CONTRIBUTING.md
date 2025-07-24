# Contributing to Project Structure Initialiser

Thank you for considering contributing to Project Structure Initialiser! This document provides guidelines and instructions for contributing to this project.

## Code of Conduct

By participating in this project, you agree to abide by our code of conduct: be respectful, considerate, and collaborative.

## How Can I Contribute?

### Reporting Bugs

Before submitting a bug report:
- Check the existing issues to see if your problem has already been reported
- If you're unable to find an existing issue addressing the problem, create a new one

When reporting bugs, please include:
- A clear and descriptive title
- Steps to reproduce the issue
- Expected behaviour vs. actual behaviour
- Any relevant logs or error messages
- Your operating system and shell information
- Screenshots if applicable

### Suggesting Enhancements

Enhancement suggestions include new features, minor improvements, or better documentation. When suggesting enhancements:
- Use a clear and descriptive title
- Provide a detailed description of the suggested enhancement
- Explain why this enhancement would be useful
- Include examples of how it would be used

### Adding New Project Types

To add support for a new project type:
1. Fork the repository
2. Create a new function `create_<type>_files()` in the main script
3. Add the new type to the `PROJECT_TYPES` array
4. Implement the file structure creation for the new project type
5. Document the new project type in the README
6. Submit a pull request

### Pull Requests

1. Fork the repository and create your branch from `main`
2. Ensure your code follows the style of the project
3. Add or update tests as necessary
4. Update documentation to reflect any changes
5. Submit a pull request

## Development Environment

1. Clone the repository:
   ```
   git clone https://github.com/warwickbrownteya/project-structure-initialiser.git
   ```

2. Make the script executable:
   ```
   chmod +x project_structure_initialiser.sh
   ```

3. Run ShellCheck to verify your changes:
   ```
   shellcheck project_structure_initialiser.sh
   ```

## Style Guidelines

### Shell Script Style

- Use 4 spaces for indentation
- Use `snake_case` for function and variable names
- Document functions with comments
- Use defensive programming (e.g., `set -euo pipefail`)
- Quote variables to prevent globbing and word splitting
- Use local variables in functions when possible
- Add helpful error messages

### Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests after the first line

## Testing

Test your changes thoroughly:
- Test with different project types
- Test with various command line options
- Test on different operating systems if possible
- Verify that all created files are properly formatted and valid

## Additional Notes

### File Naming Conventions

- Shell scripts should have the `.sh` extension
- Template files should be named descriptively
- Configuration files should follow standard conventions

### Documentation

- Update README.md when adding new features
- Document new options in the help output
- Keep examples up-to-date

## License

By contributing, you agree that your contributions will be licensed under the project's MIT License.

Thank you for contributing to Project Structure Initialiser!