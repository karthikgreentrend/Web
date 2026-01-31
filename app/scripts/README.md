# App Scripts

This directory contains operational scripts for testing and managing the application.

## Scripts

### smoke-tests.sh
Runs basic health checks against the deployed application to verify it's functioning correctly after deployment.

**Usage:**
```bash
ENVIRONMENT=dev DOMAIN=example.com ./smoke-tests.sh
```

**Environment Variables:**
- `ENVIRONMENT`: Target environment (dev, uat, prod). Default: `dev`
- `DOMAIN`: Base domain for the application. Default: `example.com`
- `MAX_RETRIES`: Number of retry attempts for failed tests. Default: `3`
- `RETRY_DELAY`: Seconds to wait between retries. Default: `5`

### game-day.sh
Interactive script for running game day scenarios to test system resilience.

**Usage:**
```bash
ENVIRONMENT=dev AWS_REGION=us-east-1 ./game-day.sh
```

**Scenarios Included:**
1. Simulate High CPU Load
2. Simulate Memory Pressure
3. Simulate Network Latency
4. Force ECS Task Restart
5. Simulate Database Connection Issues
6. Test Auto-Scaling Trigger
7. Rollback to Previous Version
8. Run All Health Checks

## Prerequisites

- AWS CLI configured with appropriate credentials
- `jq` installed for JSON parsing
- `curl` installed for HTTP requests
