#!/bin/bash
# =============================================================================
# Game Day Script
# Simulates various failure scenarios to test system resilience
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
ENVIRONMENT=${ENVIRONMENT:-"dev"}
AWS_REGION=${AWS_REGION:-"us-east-1"}
PROJECT_NAME=${PROJECT_NAME:-"greentrend"}

echo "=============================================="
echo -e "${BLUE}Game Day Scenarios${NC}"
echo "Environment: ${ENVIRONMENT}"
echo "=============================================="

# Function to show menu
show_menu() {
    echo ""
    echo "Select a scenario to run:"
    echo "1) Simulate High CPU Load"
    echo "2) Simulate Memory Pressure"
    echo "3) Simulate Network Latency"
    echo "4) Force ECS Task Restart"
    echo "5) Simulate Database Connection Issues"
    echo "6) Test Auto-Scaling Trigger"
    echo "7) Rollback to Previous Version"
    echo "8) Run All Health Checks"
    echo "9) Exit"
    echo ""
}

# Simulate High CPU Load
simulate_cpu_load() {
    echo -e "${YELLOW}Simulating high CPU load...${NC}"
    CLUSTER_NAME="${PROJECT_NAME}-${ENVIRONMENT}"
    SERVICE_NAME="${PROJECT_NAME}-${ENVIRONMENT}-backend"

    echo "This would trigger CPU stress test on ECS tasks"
    echo "In production, use AWS FIS (Fault Injection Simulator) for this"
    echo ""
    echo "Example FIS experiment:"
    echo "  aws fis start-experiment --experiment-template-id <template-id>"
}

# Simulate Memory Pressure
simulate_memory_pressure() {
    echo -e "${YELLOW}Simulating memory pressure...${NC}"
    echo "This would allocate memory to stress the containers"
    echo "Monitor CloudWatch metrics for memory utilization spikes"
}

# Simulate Network Latency
simulate_network_latency() {
    echo -e "${YELLOW}Simulating network latency...${NC}"
    echo "Using AWS FIS to inject network latency"
    echo "This would add latency to ECS tasks for testing timeout handling"
}

# Force ECS Task Restart
force_task_restart() {
    echo -e "${YELLOW}Forcing ECS task restart...${NC}"
    CLUSTER_NAME="${PROJECT_NAME}-${ENVIRONMENT}"
    SERVICE_NAME="${PROJECT_NAME}-${ENVIRONMENT}-backend"

    echo "Command to execute:"
    echo "  aws ecs update-service --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME} --force-new-deployment --region ${AWS_REGION}"
    echo ""
    read -p "Execute this command? (y/N): " confirm
    if [ "$confirm" == "y" ] || [ "$confirm" == "Y" ]; then
        aws ecs update-service --cluster "${CLUSTER_NAME}" --service "${SERVICE_NAME}" --force-new-deployment --region "${AWS_REGION}"
        echo -e "${GREEN}Task restart initiated${NC}"
    else
        echo "Cancelled"
    fi
}

# Simulate Database Connection Issues
simulate_db_issues() {
    echo -e "${YELLOW}Simulating database connection issues...${NC}"
    echo "This scenario tests application behavior when DB is unavailable"
    echo ""
    echo "Options:"
    echo "  1. Modify security group to block DB port temporarily"
    echo "  2. Use AWS FIS to inject DB connection failures"
    echo "  3. Update secrets with invalid credentials (careful!)"
}

# Test Auto-Scaling
test_autoscaling() {
    echo -e "${YELLOW}Triggering auto-scaling test...${NC}"
    echo "Generating load to trigger scaling policies"
    echo ""
    echo "You can use tools like:"
    echo "  - Apache Benchmark: ab -n 10000 -c 100 https://api.example.com/health"
    echo "  - k6: k6 run load-test.js"
    echo "  - Artillery: artillery quick --count 100 -n 50 https://api.example.com/health"
}

# Rollback
rollback_deployment() {
    echo -e "${YELLOW}Initiating rollback...${NC}"
    CLUSTER_NAME="${PROJECT_NAME}-${ENVIRONMENT}"
    SERVICE_NAME="${PROJECT_NAME}-${ENVIRONMENT}-backend"

    echo "Fetching previous task definition..."
    # Get current task definition
    CURRENT_TD=$(aws ecs describe-services --cluster "${CLUSTER_NAME}" --services "${SERVICE_NAME}" --region "${AWS_REGION}" --query 'services[0].taskDefinition' --output text 2>/dev/null || echo "unknown")
    echo "Current task definition: ${CURRENT_TD}"

    echo ""
    echo "To rollback, update the service with a previous task definition revision"
    echo "  aws ecs update-service --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME} --task-definition <previous-td> --region ${AWS_REGION}"
}

# Run Health Checks
run_health_checks() {
    echo -e "${GREEN}Running comprehensive health checks...${NC}"

    # Run smoke tests
    if [ -f "$(dirname "$0")/smoke-tests.sh" ]; then
        bash "$(dirname "$0")/smoke-tests.sh"
    else
        echo "Smoke tests script not found"
    fi

    echo ""
    echo "Checking AWS resources..."

    # Check ECS services
    echo "ECS Services:"
    aws ecs list-services --cluster "${PROJECT_NAME}-${ENVIRONMENT}" --region "${AWS_REGION}" 2>/dev/null || echo "  Unable to list services"

    # Check CloudWatch alarms
    echo ""
    echo "Active CloudWatch Alarms:"
    aws cloudwatch describe-alarms --state-value ALARM --region "${AWS_REGION}" --query 'MetricAlarms[*].[AlarmName,StateReason]' --output table 2>/dev/null || echo "  No alarms or unable to fetch"
}

# Main loop
while true; do
    show_menu
    read -p "Enter your choice (1-9): " choice

    case $choice in
        1) simulate_cpu_load ;;
        2) simulate_memory_pressure ;;
        3) simulate_network_latency ;;
        4) force_task_restart ;;
        5) simulate_db_issues ;;
        6) test_autoscaling ;;
        7) rollback_deployment ;;
        8) run_health_checks ;;
        9) echo "Exiting..."; exit 0 ;;
        *) echo -e "${RED}Invalid option${NC}" ;;
    esac

    echo ""
    read -p "Press Enter to continue..."
done
