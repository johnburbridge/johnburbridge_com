#!/bin/bash
set -e

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Installing workflow linting tools...${NC}"

# Install actionlint if not already installed
if ! command -v actionlint &> /dev/null; then
    echo "Installing actionlint..."
    brew install actionlint
fi

echo -e "\n${YELLOW}Running actionlint (GitHub Actions workflow linter)...${NC}"
actionlint

# Check if the docker image builds correctly
echo -e "\n${YELLOW}Testing Docker build with version argument...${NC}"
docker build --build-arg VERSION=0.1.0-test -t johnburbridge-site:test .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Docker build successful${NC}"
    
    # Run the container and verify version
    echo -e "\n${YELLOW}Verifying version in container...${NC}"
    container_id=$(docker run -d --rm johnburbridge-site:test)
    sleep 2
    version=$(docker exec $container_id cat /usr/share/nginx/html/version.txt)
    docker stop $container_id > /dev/null
    
    if [ "$version" == "0.1.0-test" ]; then
        echo -e "${GREEN}✓ Version correctly set in container: $version${NC}"
    else
        echo -e "${RED}✗ Version incorrect in container. Expected: 0.1.0-test, Got: $version${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ Docker build failed${NC}"
    exit 1
fi

echo -e "\n${GREEN}All validations completed successfully!${NC}"
echo -e "\n${YELLOW}Next steps:${NC}"
echo -e "1. Push changes to GitHub: git push origin feat/ci-workflows"
echo -e "2. Create a pull request to test the PR workflow"
echo -e "3. Merge the PR to test the main workflow"
echo -e "4. Manually trigger the tagging workflow to create a new version"