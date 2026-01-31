#!/bin/bash
# =============================================================================
# Smoke Tests
# Run basic health checks against the deployed application
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
ENVIRONMENT=${ENVIRONMENT:-"dev"}
DOMAIN=${DOMAIN:-"example.com"}
MAX_RETRIES=${MAX_RETRIES:-3}
RETRY_DELAY=${RETRY_DELAY:-5}

# Determine URLs based on environment
if [ "$ENVIRONMENT" == "prod" ]; then
    FRONTEND_URL="https://${DOMAIN}"
    BACKEND_URL="https://api.${DOMAIN}"
else
    FRONTEND_URL="https://${ENVIRONMENT}.${DOMAIN}"
    BACKEND_URL="https://api-${ENVIRONMENT}.${DOMAIN}"
fi

echo "=============================================="
echo "Running Smoke Tests for ${ENVIRONMENT}"
echo "=============================================="
echo "Frontend URL: ${FRONTEND_URL}"
echo "Backend URL: ${BACKEND_URL}"
echo ""

# Track test results
PASSED=0
FAILED=0

# Function to run a test with retries
run_test() {
    local name=$1
    local url=$2
    local expected_status=${3:-200}
    local retries=0

    echo -n "Testing: ${name}... "

    while [ $retries -lt $MAX_RETRIES ]; do
        status_code=$(curl -s -o /dev/null -w "%{http_code}" "${url}" --max-time 10 || echo "000")

        if [ "$status_code" == "$expected_status" ]; then
            echo -e "${GREEN}PASSED${NC} (HTTP ${status_code})"
            ((PASSED++))
            return 0
        fi

        ((retries++))
        if [ $retries -lt $MAX_RETRIES ]; then
            echo -e "${YELLOW}Retry ${retries}/${MAX_RETRIES}...${NC}"
            sleep $RETRY_DELAY
        fi
    done

    echo -e "${RED}FAILED${NC} (Expected: ${expected_status}, Got: ${status_code})"
    ((FAILED++))
    return 1
}

# Function to test JSON endpoint
test_json_endpoint() {
    local name=$1
    local url=$2
    local expected_field=$3

    echo -n "Testing: ${name}... "

    response=$(curl -s "${url}" --max-time 10 || echo "{}")

    if echo "$response" | jq -e ".${expected_field}" > /dev/null 2>&1; then
        echo -e "${GREEN}PASSED${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}FAILED${NC} (Field '${expected_field}' not found)"
        ((FAILED++))
        return 1
    fi
}

echo "--- Frontend Tests ---"
run_test "Frontend Homepage" "${FRONTEND_URL}" 200
run_test "Frontend Static Assets" "${FRONTEND_URL}/static/js/main.js" 200

echo ""
echo "--- Backend API Tests ---"
run_test "Backend Health Check" "${BACKEND_URL}/health" 200
run_test "Backend API Root" "${BACKEND_URL}/api" 200
test_json_endpoint "Backend Health JSON" "${BACKEND_URL}/health" "status"

echo ""
echo "=============================================="
echo "Smoke Test Results"
echo "=============================================="
echo -e "Passed: ${GREEN}${PASSED}${NC}"
echo -e "Failed: ${RED}${FAILED}${NC}"
echo ""

if [ $FAILED -gt 0 ]; then
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
else
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
fi
