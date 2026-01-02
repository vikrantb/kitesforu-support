# Contributing to kiteagentcollab

Thank you for your interest in contributing to kiteagentcollab! This document provides guidelines for contributions.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Workflow](#development-workflow)
- [Documentation Guidelines](#documentation-guidelines)
- [Testing Guidelines](#testing-guidelines)
- [Submitting Changes](#submitting-changes)
- [Community and Support](#community-and-support)

---

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of experience level, background, or identity.

### Expected Behavior

- Be respectful and constructive in all interactions
- Welcome newcomers and help them get started
- Accept constructive criticism gracefully
- Focus on what is best for the community and framework
- Show empathy towards other community members

### Unacceptable Behavior

- Harassment, discrimination, or offensive comments
- Personal attacks or trolling
- Publishing others' private information
- Other conduct which could reasonably be considered inappropriate

### Enforcement

Violations can be reported to [contact email]. All complaints will be reviewed and investigated promptly and fairly.

---

## Getting Started

### Prerequisites

- **Git**: For version control
- **Markdown editor**: For documentation
- **Understanding of**:
  - Claude Code basics
  - Cursor IDE (Codex) basics
  - Collaborative AI workflows

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/your-username/kiteagentcollab.git
   cd kiteagentcollab
   ```
3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/[your-org]/kiteagentcollab.git
   ```

### Repository Structure

```
kiteagentcollab/
├── docs/              # Documentation
│   ├── 00-getting-started.md
│   ├── 01-protocol-v2.5.md
│   ├── 02-delegation-framework.md
│   ├── 03-codex-protocol.md
│   └── 05-best-practices.md
├── templates/         # Teamchat templates
│   ├── teamchat-v2.5-template.md
│   ├── debugging-scenario.md
│   ├── design-review-scenario.md
│   ├── implementation-scenario.md
│   └── testing-scenario.md
├── examples/          # Integration examples
├── scripts/           # Automation scripts
├── README.md
├── CHANGELOG.md
├── LICENSE
└── CONTRIBUTING.md
```

---

## How to Contribute

### Ways to Contribute

1. **Report Bugs**: Found an issue? Let us know!
2. **Suggest Enhancements**: Have ideas for improvement?
3. **Improve Documentation**: Fix typos, clarify concepts, add examples
4. **Create Examples**: Share integration patterns from your projects
5. **Write Templates**: Add new scenario templates
6. **Develop Scripts**: Build automation tools
7. **Share Experiences**: Document patterns and anti-patterns

### Before You Start

- Check existing issues to avoid duplicates
- Read relevant documentation
- Discuss major changes in an issue first
- Review [Best Practices](docs/05-best-practices.md)

---

## Development Workflow

### Branching Strategy

- `main`: Production-ready code
- `develop`: Integration branch for features
- `feature/*`: New features or enhancements
- `bugfix/*`: Bug fixes
- `docs/*`: Documentation improvements

### Branch Naming

```
feature/delegation-ui-automation
bugfix/yaml-parsing-issue
docs/improve-getting-started
```

### Making Changes

1. **Create a branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**:
   - Follow existing code/documentation style
   - Keep changes focused and atomic
   - Write clear, descriptive commits

3. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat: add delegation decision tree

   - Add visual decision tree for delegation
   - Include examples for each branch
   - Update best practices document"
   ```

4. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

### Commit Message Format

Follow conventional commits:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Formatting changes
- `refactor`: Code restructuring
- `test`: Test additions or changes
- `chore`: Maintenance tasks

**Examples**:
```
feat(delegation): add token management priority

Implement Priority 3 delegation for token management scenarios.
Includes decision tree and usage examples.

Closes #123
```

```
docs(protocol): clarify YAML frontmatter format

Add examples and clarify field descriptions in Protocol v2.5
documentation.
```

---

## Documentation Guidelines

### Writing Style

- **Clear and Concise**: Get to the point quickly
- **Examples**: Provide concrete examples
- **Formatting**: Use headers, lists, and code blocks
- **Links**: Reference related documentation
- **Markdown**: Follow GitHub Flavored Markdown

### Documentation Structure

**Headers**:
```markdown
# Main Title (H1)
## Section (H2)
### Subsection (H3)
```

**Code Blocks**:
```markdown
```language
code here
```​
```

**Lists**:
```markdown
- Bullet point
- Another point
  - Nested point

1. Numbered list
2. Second item
```

**Links**:
```markdown
[Link text](../path/to/file.md)
```

### Adding New Documentation

1. Place in appropriate `docs/` subdirectory
2. Update README.md table of contents
3. Cross-reference from related documents
4. Follow existing documentation patterns

---

## Testing Guidelines

### Documentation Testing

- **Spell check**: Use spell checker
- **Link validation**: Ensure all links work
- **Code examples**: Verify all code examples are correct
- **Format check**: Ensure Markdown renders correctly

### Template Testing

When adding or modifying templates:

1. **Test with real scenario**: Use template in actual collaboration
2. **Validate YAML**: Ensure YAML frontmatter is valid
3. **Check completeness**: All sections make sense
4. **Verify clarity**: Instructions are clear
5. **Example data**: Placeholder data is appropriate

### Script Testing

If contributing automation scripts:

1. **Unit tests**: Write tests for all functions
2. **Integration tests**: Test end-to-end workflows
3. **Error handling**: Test failure scenarios
4. **Documentation**: Include usage examples
5. **Cross-platform**: Test on multiple OS if applicable

---

## Submitting Changes

### Pull Request Process

1. **Update Documentation**:
   - Update README.md if adding features
   - Update CHANGELOG.md with your changes
   - Add or update relevant docs

2. **Self-Review**:
   - Read through all changes
   - Ensure code/docs follow style guidelines
   - Check for typos and errors
   - Verify all examples work

3. **Create Pull Request**:
   - Use clear, descriptive title
   - Fill out PR template completely
   - Link related issues
   - Add screenshots if relevant

4. **Address Review Feedback**:
   - Respond to all comments
   - Make requested changes
   - Keep discussion focused and professional
   - Thank reviewers for their time

### Pull Request Template

```markdown
## Description
[Clear description of what this PR does]

## Motivation and Context
[Why is this change needed? What problem does it solve?]

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation improvement
- [ ] Breaking change

## Testing
- [ ] Tested with real collaboration scenario
- [ ] Documentation builds without errors
- [ ] All links validated
- [ ] Examples verified

## Screenshots (if applicable)
[Add screenshots showing the change]

## Checklist
- [ ] Code/docs follow style guidelines
- [ ] CHANGELOG.md updated
- [ ] Self-review completed
- [ ] No breaking changes (or documented)

## Related Issues
Closes #[issue number]
```

### Review Process

1. **Automated Checks**: PR must pass any automated checks
2. **Peer Review**: At least one maintainer reviews
3. **Feedback**: Address or discuss feedback
4. **Approval**: Maintainer approves PR
5. **Merge**: Maintainer merges to appropriate branch

---

## Community and Support

### Getting Help

- **Documentation**: Check [docs/](docs/) first
- **Issues**: Search existing issues
- **Discussions**: Use GitHub Discussions for questions
- **Examples**: Review [examples/](examples/) directory

### Asking Questions

When asking questions:

1. **Search First**: Check if already answered
2. **Be Specific**: Provide context and details
3. **Show Effort**: Explain what you've tried
4. **Minimal Example**: Provide minimal reproduction if applicable

### Proposing Changes

For significant changes:

1. **Open Issue First**: Discuss before coding
2. **Explain Motivation**: Why is this needed?
3. **Consider Alternatives**: What other approaches exist?
4. **Scope**: Keep changes focused
5. **Backward Compatibility**: Avoid breaking changes

---

## Contribution Types

### Bug Reports

**Good Bug Report Includes**:
- Clear, descriptive title
- Steps to reproduce
- Expected vs actual behavior
- Environment details
- Screenshots or examples
- Possible solution (if you have ideas)

**Template**:
```markdown
## Bug Description
[Clear description of the bug]

## Steps to Reproduce
1. [First step]
2. [Second step]
3. [Issue occurs]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- OS: [e.g., macOS 14.1]
- Claude Code version: [version]
- Cursor version: [version]

## Additional Context
[Any other relevant information]
```

### Feature Requests

**Good Feature Request Includes**:
- Clear problem statement
- Proposed solution
- Alternative solutions considered
- Use cases and examples
- Potential impact

**Template**:
```markdown
## Feature Request

**Problem**: [What problem does this solve?]

**Proposed Solution**: [Your suggested approach]

**Alternatives Considered**: [Other approaches you thought about]

**Use Cases**:
1. [Use case 1]
2. [Use case 2]

**Examples**: [Concrete examples of the feature in use]
```

### Documentation Improvements

Areas often needing improvement:
- Typos and grammar fixes
- Clarity improvements
- Additional examples
- Missing edge cases
- Better explanations
- Updated screenshots
- Cross-references

---

## Style Guidelines

### Markdown Style

- Use ATX-style headers (`#` not underline)
- One blank line before and after headers
- Code blocks specify language
- Lists have consistent formatting
- Links use reference style when repeated

### Code Style

For automation scripts (if contributing):
- **Python**: Follow PEP 8
- **JavaScript**: Follow Airbnb style guide
- **Comments**: Explain why, not what
- **Functions**: Single responsibility principle

### YAML Style

For frontmatter and templates:
```yaml
---
key: "value"  # Use quotes for strings
number: 42    # No quotes for numbers
list:         # Consistent indentation (2 spaces)
  - item1
  - item2
nested:
  child: "value"
---
```

---

## Recognition

Contributors are recognized in:
- GitHub contributors list
- CHANGELOG.md for significant contributions
- Project documentation (if appropriate)
- Community acknowledgments

---

## Release Process

For maintainers:

1. **Version Bump**: Update version in CHANGELOG.md
2. **Documentation**: Ensure docs are current
3. **Testing**: Run full test suite
4. **Tag**: Create git tag for release
5. **Publish**: Push to main and create GitHub release
6. **Announce**: Announce in discussions and relevant channels

---

## Questions?

- **General Questions**: Use GitHub Discussions
- **Bug Reports**: Open an issue
- **Security Issues**: Email [security contact]
- **Other**: Reach out to maintainers

---

## License

By contributing to kiteagentcollab, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to kiteagentcollab! 🚀

Your contributions help make AI collaboration more effective for everyone.
