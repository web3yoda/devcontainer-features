#!/bin/sh
set -e

echo "Activating feature 'useful-utils'"
echo "The provided favorite useful-utils is: ${FAVORITE}"

OS_TYPE=$(uname -s | awk '{print(tolower($0))}')
OS_ARCH=$(uname -m | sed 's/x86_/amd/' | sed 's/aarch/arm/' | awk '{print(tolower($0))}')

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

YQ_REPO=mikefarah/yq
DASEL_REPO=TomWright/dasel
GUM_REPO=charmbracelet/gum
GOMPLATE_REPO=hairyhenderson/gomplate
TASK_REPO=go-task/task
W3T_REPO=shidaxi/w3t
SUPERVISORD_REPO=shidaxi/supervisord
SESSION_MANAGER_PLUGIN_REPO=aws/session-manager-plugin

# Install yq
if [ "${YQ_VERSION}" = "latest" ]; then
    YQ_VERSION=$(get_latest_release ${YQ_REPO})
fi
echo "Installing yq ${YQ_VERSION}"
curl -sSL https://github.com/${YQ_REPO}/releases/download/${YQ_VERSION}/yq_${OS_TYPE}_${OS_ARCH} -o /usr/local/bin/yq
chmod +x /usr/local/bin/yq

# Install dasel
if [ "${DASEL_VERSION}" = "latest" ]; then
    DASEL_VERSION=$(get_latest_release ${DASEL_REPO})
fi
echo "Installing dasel ${DASEL_VERSION}"
curl -sSL https://github.com/${DASEL_REPO}/releases/download/${DASEL_VERSION}/dasel_${OS_TYPE}_${OS_ARCH} -o /usr/local/bin/dasel
chmod +x /usr/local/bin/dasel

# Install gum
if [ "${GUM_VERSION}" = "latest" ]; then
    GUM_VERSION=$(get_latest_release ${GUM_REPO})
fi
echo "Installing gum ${GUM_VERSION}"
curl -sSL https://github.com/${GUM_REPO}/releases/download/${GUM_VERSION}/gum_$(echo ${GUM_VERSION} | sed 's/v//')_${OS_ARCH}.deb -o gum_${OS_ARCH}.deb
dpkg -i gum_${OS_ARCH}.deb && rm gum_${OS_ARCH}.deb

# Install gomplate
if [ "${GOMPLATE_VERSION}" = "latest" ]; then
    GOMPLATE_VERSION=$(get_latest_release ${GOMPLATE_REPO})
fi
echo "Installing gomplate ${GOMPLATE_VERSION}"
curl -sSL https://github.com/${GOMPLATE_REPO}/releases/download/${GOMPLATE_VERSION}/gomplate_${OS_TYPE}-${OS_ARCH} -o /usr/local/bin/gomplate
chmod +x /usr/local/bin/gomplate

# Install go-task
if [ "${TASK_VERSION}" = "latest" ]; then
    TASK_VERSION=$(get_latest_release ${TASK_REPO})
fi
echo "Installing task ${TASK_VERSION}"
curl -sSL https://github.com/${TASK_REPO}/releases/download/${TASK_VERSION}/task_${OS_TYPE}_${OS_ARCH}.tar.gz \
  | tar xzf - -C /usr/local/bin

# Install w3t
if [ "${W3T_VERSION}" = "latest" ]; then
    W3T_VERSION=$(get_latest_release ${W3T_REPO})
fi
echo "Installing w3t ${W3T_VERSION}"
curl -sSL https://github.com/${W3T_REPO}/releases/download/${W3T_VERSION}/w3t_$(echo ${W3T_VERSION} | sed 's/v//')_${OS_TYPE}_${OS_ARCH}.tar.gz \
  | tar xzf - -C /usr/local/bin

# install supervisord
BIN_PATH=/usr/local/bin/supervisord
curl --progress-bar -SL https://github.com/${SUPERVISORD_REPO}/releases/download/v0.7.3-envfiles/supervisord-v0.7.3-envfiles-${OS_TYPE}-${OS_ARCH} \
  -o ${BIN_PATH} && chmod +x ${BIN_PATH}

if [ "${SESSION_MANAGER_PLUGIN_VERSION}" = "latest" ]; then
    SESSION_MANAGER_PLUGIN_VERSION=$(get_latest_release ${SESSION_MANAGER_PLUGIN_REPO})
fi
# install session-manager-plugin
echo "Installing session-manager-plugin latest"
curl -sSL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_$(echo ${OS_ARCH} | sed 's/amd64/64bit/')/session-manager-plugin.deb" -o "session-manager-plugin.deb"
dpkg -i session-manager-plugin.deb && rm session-manager-plugin.deb
