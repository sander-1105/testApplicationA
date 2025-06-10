# testApplicationA

# CI/CD Pipeline Documentation

## Overview
This repository uses GitHub Actions for continuous integration and deployment. The pipeline automatically manages version updates and Helm chart synchronization.

## Workflow Structure

### Trigger Conditions
The workflow is triggered on:
- Push to `main` branch
- Pull requests to `main` branch
- Manual trigger (workflow_dispatch)

### Jobs

#### 1. Version Check
- Checks if the VERSION file has been modified
- Skips the build if no version changes are detected
- Handles first commit scenarios appropriately

#### 2. Setup
- Sets up Python environment
- Configures dependency caching
- Prepares the build environment

#### 3. Version Update
- Reads current version from VERSION file
- Increments the version number
- Updates the VERSION file
- Creates and pushes a new version tag

#### 4. Chart Update
- Updates the Helm chart repository
- Synchronizes the new version with the chart
- Uses SSH for secure repository access

#### 5. Notification
- Sends build status notifications
- Creates GitHub issues for build results

## Prerequisites

### Required Secrets
Add the following secrets to your GitHub repository (Settings > Secrets and variables > Actions):

1. `SSH_PRIVATE_KEY`
   - SSH private key for accessing the Helm chart repository
   - Used for secure Git operations

2. `PAT` (Personal Access Token)
   - GitHub Personal Access Token
   - Used for repository operations

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

## Concurrency Control

The workflow implements concurrency control to:
- Prevent parallel runs of the same workflow
- Cancel in-progress runs when new commits are pushed
- Group runs by workflow and branch

## Timeout Settings

Each job has a 30-minute timeout to prevent hanging workflows.

## Error Handling

The workflow includes comprehensive error handling:
- File existence checks
- Version format validation
- Git operation error handling
- SSH connection error handling
- Chart update error handling

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

2. **Chart Update Fails**
   - Verify SSH_PRIVATE_KEY secret is correctly set
   - Check if helm-chart-ssh-url in ci.yml is correct
   - Ensure SSH key has access to the chart repository

3. **Permission Issues**
   - Verify all required permissions are set
   - Check if PAT has sufficient permissions
   - Ensure SSH key has correct permissions

### Logs and Debugging

- Check the Actions tab in GitHub for detailed logs
- Each job provides step-by-step execution logs
- Error messages are clearly displayed in the workflow run

## Best Practices

1. **Version Management**
   - Always update VERSION file for new releases
   - Follow semantic versioning (x.y.z)
   - Commit version changes separately

2. **Security**
   - Regularly rotate SSH keys and PAT
   - Use repository secrets for sensitive data
   - Review workflow permissions regularly

3. **Maintenance**
   - Keep actions up to date
   - Monitor workflow execution times
   - Review and update timeout settings as needed