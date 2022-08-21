#!/bin/sh

bundle install
bundle exec fastlane renew_codesign_development
bundle exec fastlane renew_codesign_staging
bundle exec fastlane renew_codesign_release
