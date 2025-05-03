#!/usr/bin/env bash
set -o errexit

# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile


npm install --prefix assets
npm run deploy --prefix assets

# Compile assets
# Make sure tailwind and esbuild are installed
MIX_ENV=prod mix assets.build
# Build minified assets
MIX_ENV=prod mix assets.deploy

# Create server script, Build the release, and overwrite the existing release directory
MIX_ENV=prod mix phx.gen.release
MIX_ENV=prod mix release --overwrite
