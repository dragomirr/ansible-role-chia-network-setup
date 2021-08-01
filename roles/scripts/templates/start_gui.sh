#!/bin/bash

set -e

cd {{ blockchain.directory }}/chia-blockchain-gui
source ../activate
npm run electron
