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

## Install Ethereum Tools
# Install foundry-rs
echo "Installing foundry-rs ${FOUNDRY_VERSION}"
curl --progress-bar -SL https://github.com/foundry-rs/foundry/releases/download/$(echo ${FOUNDRY_VERSION} | sed 's/v//')/foundry_nightly_${OS_TYPE}_${OS_ARCH}.tar.gz \
  | tar xzf - -C /usr/local/bin

# Install go-ethereum
echo "Installing go-ethereum ${GETH_VERSION}"
curl --progress-bar -sSL https://gethstore.blob.core.windows.net/builds/geth-alltools-${OS_TYPE}-${OS_ARCH}-$(echo ${GETH_VERSION} | sed 's/v//').tar.gz \
  | tar xzf - -C /usr/local/bin --strip-components 1

# Install prysm
echo "Installing prysm ${PRYSM_VERSION}"
for bin in beacon-chain validator prysmctl; do 
curl --progress-bar -SL https://github.com/prysmaticlabs/prysm/releases/download/${PRYSM_VERSION}/${bin}-${PRYSM_VERSION}-${OS_TYPE}-${OS_ARCH} \
  -o /usr/local/bin/${bin}
chmod +x /usr/local/bin/${bin}
done

## Install Cosmos Tools
# Install gaia
echo "Installing gaiad ${GAIA_VERSION}"
curl --progress-bar -SL https://github.com/ignite/cli/releases/download/${GAIA_VERSION}/gaiad-${GAIA_VERSION}-${OS_TYPE}-${OS_ARCH} \
  -o /usr/local/bin/gaiad && chmod +x /usr/local/bin/gaiad

# Install ignite
echo "Installing ignite ${IGNITE_VERSION}"
curl --progress-bar -SL https://github.com/ignite/cli/releases/download/${IGNITE_VERSION}/ignite_${IGNITE_VERSION}_${OS_TYPE}_${OS_ARCH} \
  -o /usr/local/bin/ignite && chmod +x /usr/local/bin/ignite
