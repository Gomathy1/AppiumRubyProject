#!/bin/bash

echo "🚀 Setting up Appium Ruby Project..."
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Check Ruby version
echo "📋 Step 1: Checking Ruby version..."
if command -v ruby &> /dev/null; then
    RUBY_VERSION=$(ruby -v)
    echo -e "${GREEN}✅ Ruby installed: $RUBY_VERSION${NC}"
else
    echo -e "${RED}❌ Ruby not found. Please install Ruby 3.0+${NC}"
    exit 1
fi

# Step 2: Install Bundler
echo ""
echo "📦 Step 2: Installing Bundler..."
if command -v bundle &> /dev/null; then
    echo -e "${GREEN}✅ Bundler already installed${NC}"
else
    gem install bundler
    echo -e "${GREEN}✅ Bundler installed${NC}"
fi

# Step 3: Initialize Git repository
echo ""
echo "🔧 Step 3: Initializing Git repository..."
if [ -d .git ]; then
    echo -e "${YELLOW}⚠️  Git repository already initialized${NC}"
else
    git init
    git branch -M master
    echo -e "${GREEN}✅ Git repository initialized${NC}"
fi

# Step 4: Install Ruby gems
echo ""
echo "💎 Step 4: Installing Ruby gems..."
bundle install
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ All gems installed successfully${NC}"
else
    echo -e "${RED}❌ Failed to install gems${NC}"
    exit 1
fi

# Step 5: Create .env file if not exists
echo ""
echo "⚙️  Step 5: Setting up environment..."
if [ ! -f .env ]; then
    cp .env.example .env
    echo -e "${GREEN}✅ .env file created from .env.example${NC}"
    echo -e "${YELLOW}⚠️  Please update .env with your configuration${NC}"
else
    echo -e "${YELLOW}⚠️  .env file already exists${NC}"
fi

# Step 6: Create necessary directories
echo ""
echo "📁 Step 6: Creating directories..."
mkdir -p reports screenshots logs allure-results
echo -e "${GREEN}✅ Directories created${NC}"

# Step 7: Verify installation
echo ""
echo "✅ Step 7: Verifying installation..."
echo ""
echo "Cucumber version:"
bundle exec cucumber --version
echo ""
echo "RSpec version:"
bundle exec rspec --version
echo ""

# Step 8: Run a quick test
echo ""
echo "🧪 Step 8: Running quick test..."
bundle exec rspec spec/unit/appium_config_spec.rb --format documentation
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Quick test passed!${NC}"
else
    echo ""
    echo -e "${YELLOW}⚠️  Some tests failed, but setup is complete${NC}"
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}🎉 Setup Complete!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "1. Update .env file with your configuration"
echo "2. Run tests: bundle exec cucumber -p smoke"
echo "3. View reports: open reports/smoke_report.html"
echo ""
echo "For CI/CD setup, see: SETUP_CHECKLIST.md"
echo "For testing guide, see: TESTING_THE_AUTOMATION.md"
echo ""
echo -e "${GREEN}Happy Testing! 🚀${NC}"
echo ""
