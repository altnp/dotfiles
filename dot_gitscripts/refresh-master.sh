#!/usr/bin/env bash

LYELLOW='\033[1;33m'
NC='\033[0m' # No Color
RED='\033[1;31m'

echo -e "${LYELLOW}Checkingout Master...${NC}"
git checkout master
echo ""

branchname=$(git rev-parse --abbrev-ref HEAD)
if [ "$branchname" != "master" ]; then
    echo -e "${RED}Error:: unable to checkout master!${NC}"
    echo ""
    exit 1
fi

echo -e "${LYELLOW}Reseting modified files...${NC}"
git checkout .
echo ""
echo -e "${LYELLOW}Cleaning untracked files...${NC}"
git clean -xfd
echo ""
echo -e "${LYELLOW}Fetching...${NC}"
git fetch --all -p
echo ""
git status -s
echo ""
echo -e "${LYELLOW}Pulling into master...${NC}"
git pull
echo ""
echo -e "${LYELLOW}Last Commit:${NC}"
git log -1
