# testApplicationA

# CI/CD Pipeline Documentation

## Overview
This repository uses GitHub Actions for continuous integration and deployment. The pipeline automatically manages version updates and Helm chart synchronization.

## Workflow Structure

### Trigger Conditions
The workflow is triggered on:
- Push to `main` branch
- Pull requests to `main` branch (only on opened and reopened)
- Manual trigger (workflow_dispatch)

### Jobs

#### 1. Version Check
- Checks if the VERSION file has been modified
- Skips the build if no version changes are detected
- Handles first commit scenarios appropriately
- Only runs on push events or PR open/reopen events

#### 2. Setup
- Sets up Python environment
- Configures dependency caching
- Prepares the build environment

#### 3. Version Update
- Reads current version from VERSION file
- Increments the version number
- Updates the VERSION file
- Creates and pushes a new version tag
- Ensures proper branch checkout before pushing changes

#### 4. Chart Update
- Updates the Helm chart repository
- Synchronizes the new version with the chart
- Uses SSH for secure repository access
- Handles SSH key setup automatically

#### 5. Notification
- Sends build status notifications via GitHub Issues
- Includes detailed build information
- Gracefully handles notification failures
- Provides workflow and run context

## Prerequisites

### Required Secrets
Add the following secrets to your GitHub repository (Settings > Secrets and variables > Actions):

1. `SSH_PRIVATE_KEY`
   - SSH private key for accessing the Helm chart repository
   - Used for secure Git operations
   - Must have access to the Helm chart repository

2. `PAT` (Personal Access Token)
   - GitHub Personal Access Token
   - Used for repository operations
   - Must have appropriate permissions

### Automatic Secrets

1. `GITHUB_TOKEN`
   - Automatically provided by GitHub Actions
   - No manual setup required
   - Used for repository operations within the workflow
   - Has permissions based on the workflow's permission settings
   - Automatically rotated for each workflow run

### Required Files

1. `VERSION` file
   - Must exist in the repository root
   - Format: `export VERSION=x.y.z`
   - Example: `export VERSION=0.0.0`

2. `ci.yml` file
   - Must exist in the repository root
   - Contains the Helm chart repository URL
   - Format: `helm-chart-ssh-url: "git@github.com:owner/repo.git"`

## Permissions

The workflow requires the following permissions:
- `contents: write` - For pushing code and tags
- `packages: write` - For package operations
- `pull-requests: write` - For creating notifications
- `issues: write` - For creating build status issues

## Concurrency Control

The workflow implements concurrency control to:
- Prevent parallel runs of the same workflow
- Cancel in-progress runs when new commits are pushed
- Group runs by workflow and PR number (for PRs) or branch (for pushes)

## Timeout Settings

Each job has a 30-minute timeout to prevent hanging workflows.

## Error Handling

The workflow includes comprehensive error handling:
- File existence checks
- Version format validation
- Git operation error handling
- SSH connection error handling
- Chart update error handling
- Notification error handling (non-blocking)

## Manual Trigger

To manually trigger the workflow:
1. Go to the "Actions" tab in your GitHub repository
2. Select the "Build and Version Management" workflow
3. Click "Run workflow"
4. Select the branch to run on
5. Click "Run workflow"

## Troubleshooting

### Common Issues

1. **Version Update Fails**
   - Check if VERSION file exists and has correct format
   - Verify repository permissions
   - Check if version number is valid
   - Ensure proper branch checkout

2. **Chart Update Fails**
   - Verify SSH_PRIVATE_KEY secret is correctly set
   - Check if helm-chart-ssh-url in ci.yml is correct
   - Ensure SSH key has access to the chart repository
   - Check SSH key permissions (should be 600)

3. **Permission Issues**
   - Verify all required permissions are set
   - Check if PAT has sufficient permissions
   - Ensure SSH key has correct permissions
   - Verify repository settings allow workflow access
   - Check if GITHUB_TOKEN has required permissions

4. **Notification Issues**
   - Check if issues are enabled in the repository
   - Verify workflow has issues:write permission
   - Check GitHub token permissions

### Logs and Debugging

- Check the Actions tab in GitHub for detailed logs
- Each job provides step-by-step execution logs
- Error messages are clearly displayed in the workflow run
- Notification failures are logged but don't fail the workflow

## Best Practices

1. **Version Management**
   - Always update VERSION file for new releases
   - Follow semantic versioning (x.y.z)
   - Commit version changes separately
   - Ensure proper branch checkout before pushing

2. **Security**
   - Regularly rotate SSH keys and PAT
   - Use repository secrets for sensitive data
   - Review workflow permissions regularly
   - Keep SSH key permissions secure (600)
   - Use GITHUB_TOKEN for internal repository operations

3. **Maintenance**
   - Keep actions up to date
   - Monitor workflow execution times
   - Review and update timeout settings as needed
   - Regularly check notification delivery

4. **PR Management**
   - Use PR templates if needed
   - Review PR checks before merging
   - Monitor build notifications
   - Keep PR branches up to date