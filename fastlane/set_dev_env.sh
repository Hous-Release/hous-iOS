#!/bin/sh

bundle install
bundle exec fastlane sync_codesign_development
bundle exec fastlane sync_codesign_staging
bundle exec fastlane sync_codesign_release
