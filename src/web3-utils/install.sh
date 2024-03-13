#!/bin/sh
set -e

echo "Activating feature 'useful-utils'"
echo "The provided favorite useful-utils is: ${FAVORITE}"

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

OS_TYPE=$(uname -s | awk '{print(tolower($0))}')
OS_ARCH=$(uname -m | sed 's/x86_/amd/' | awk '{print(tolower($0))}')

GETH_REPO=ethereum/go-ethereum

# Install foundry-rs
echo "Installing foundry-rs ${FOUNDRY_VERSION}"
curl --progress-bar -SL https://github.com/foundry-rs/foundry/releases/download/${FOUNDRY_VERSION//v/}/foundry_nightly_${OS_TYPE}_${OS_ARCH}.tar.gz \
  | tar xzf - -C /usr/local/bin

# Install go-ethereum
echo "Installing go-ethereum ${GETH_VERSION}"
curl --progress-bar -sSL https://gethstore.blob.core.windows.net/builds/geth-alltools-${OS_TYPE}-${OS_ARCH}-${GETH_VERSION//v/}.tar.gz \
  | tar xzf - -C /usr/local/bin --strip-components 1

# Install prysm
echo "Installing prysm ${PRYSM_VERSION}"
for bin in beacon-chain validator prysmctl; do 
curl --progress-bar -SL https://github.com/prysmaticlabs/prysm/releases/download/${PRYSM_VERSION}/${bin}-${PRYSM_VERSION}-${OS_TYPE}-${OS_ARCH} \
  -o /usr/local/bin/${bin}
done