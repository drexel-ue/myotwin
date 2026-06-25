#!/usr/bin/env bash
# MyoTwin Monorepo Bootstrap Script

set -e

echo "🚀 Bootstrapping MyoTwin Development Environment..."
echo "=================================================="

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# 0. Check for Homebrew (essential for automated installs on macOS)
if ! command_exists brew; then
  echo "❌ Error: Homebrew is not installed."
  echo "Please install Homebrew first: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
  exit 1
fi

# 1. Check & Install Python 3
if command_exists python3; then
  echo "✅ Python 3 is installed: $(python3 --version 2>&1)"
else
  echo "⚠️ Python 3 is not installed. Installing via Homebrew..."
  brew install python
  
  if command_exists python3; then
    echo "✅ Python 3 installed successfully."
  else
    echo "❌ Failed to install Python 3."
    exit 1
  fi
fi

# 2. Check & Install pip
if command_exists pip3; then
  echo "✅ pip3 is installed: $(pip3 --version | awk '{print $2}')"
else
  echo "⚠️ pip3 is not installed. Attempting to ensure pip..."
  python3 -m ensurepip --upgrade
  
  if command_exists pip3; then
    echo "✅ pip3 ensured successfully."
  else
    echo "❌ Failed to ensure pip3."
    exit 1
  fi
fi

# 3. Check & Install Flutter (which includes Dart)
if command_exists flutter; then
  echo "✅ Flutter is installed: $(flutter --version | head -n 1 | awk '{print $2}')"
else
  echo "⚠️ Flutter is not installed. Installing via Homebrew Cask..."
  brew install --cask flutter
  
  if command_exists flutter; then
    echo "✅ Flutter installed successfully."
  else
    echo "❌ Failed to install Flutter."
    exit 1
  fi
fi

# 4. Check Dart (should be available if Flutter is installed)
if command_exists dart; then
  echo "✅ Dart is installed: $(dart --version 2>&1 | awk '{print $4}')"
else
  echo "❌ Error: Dart command not found even though Flutter was installed. You may need to restart your terminal or check your PATH."
  exit 1
fi

echo "=================================================="
echo "📦 Installing Project Dependencies..."

# 5. Setup Python Virtual Environment and Install dependencies
echo "🐍 Setting up Python virtual environment in packages/motus_cli/.venv..."
python3 -m venv packages/motus_cli/.venv
source packages/motus_cli/.venv/bin/activate
echo "📦 Installing Python dependencies for motus_cli..."
pip3 install PyMuPDF --quiet
deactivate
echo "✅ PyMuPDF installed in local .venv."

# 6. Activate Melos and Bootstrap Workspace
echo "Activating Melos..."
dart pub global activate melos

echo "Bootstrapping Workspace with Melos..."
# Because this is a Dart 3.5 workspace, running pub get from the root might be enough, 
# but we run melos bootstrap to be safe and link any remaining dependencies.
melos bootstrap

echo "=================================================="
echo "🎉 Bootstrap Complete!"
echo "You can now run the Motus CLI with: dart run packages/motus_cli/bin/motus_cli.dart"
