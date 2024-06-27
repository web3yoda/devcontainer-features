#!/bin/sh
set -e

echo "Activating feature 'useful-utils'"
echo "The provided favorite useful-utils is: ${FAVORITE}"

export OS_TYPE=$(uname -s | awk '{print(tolower($0))}')
export OS_ARCH=$(uname -m | sed 's/x86_/amd/' | awk '{print(tolower($0))}')

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

YQ_REPO=mikefarah/yq
GUM_REPO=charmbracelet/gum
GOMPLATE_REPO=hairyhenderson/gomplate
SESSION_MANAGER_PLUGIN_REPO=aws/session-manager-plugin

if [ "${YQ_VERSION}" = "latest" ]; then
    YQ_VERSION=$(get_latest_release ${YQ_REPO})
fi

# Install yq
echo "Installing yq ${YQ_VERSION}"
curl -sSL https://github.com/${YQ_REPO}/releases/download/${YQ_VERSION}/yq_${OS_TYPE}_${OS_ARCH} -o /usr/local/bin/yq
chmod +x /usr/local/bin/yq

if [ "${GUM_VERSION}" = "latest" ]; then
    GUM_VERSION=$(get_latest_release ${GUM_REPO})
fi
# Install gum
echo "Installing gum ${GUM_VERSION}"
curl -sSL https://github.com/${GUM_REPO}/releases/download/${GUM_VERSION}/gum_$(echo ${GUM_VERSION} | sed 's/v//')_${OS_ARCH}.deb -o gum_${OS_ARCH}.deb
dpkg -i gum_${OS_ARCH}.deb && rm gum_${OS_ARCH}.deb

if [ "${GOMPLATE_VERSION}" = "latest" ]; then
    GOMPLATE_VERSION=$(get_latest_release ${GOMPLATE_REPO})
fi
# Install gomplate
echo "Installing gomplate ${GOMPLATE_VERSION}"
curl -sSL https://github.com/${GOMPLATE_REPO}/releases/download/${GOMPLATE_VERSION}/gomplate_${OS_TYPE}-${OS_ARCH}-slim -o /usr/local/bin/gomplate
chmod +x /usr/local/bin/gomplate

if [ "${SESSION_MANAGER_PLUGIN_VERSION}" = "latest" ]; then
    SESSION_MANAGER_PLUGIN_VERSION=$(get_latest_release ${SESSION_MANAGER_PLUGIN_REPO})
fi

# install session-manager-plugin
echo "Installing session-manager-plugin latest"
curl -sSL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_${OS_TYPE/amd64/64bit}/session-manager-plugin.deb" -o "session-manager-plugin.deb"
dpkg -i session-manager-plugin.deb && rm session-manager-plugin.deb
