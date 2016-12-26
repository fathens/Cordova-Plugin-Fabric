#!/usr/bin/env ruby

require 'pathname'
require_relative '../../../lib/cordova_plugin_fabric'

$PROJECT_DIR = Pathname.pwd.realpath
$PLATFORM_DIR = $PROJECT_DIR/'platforms'/'android'

Fabric::modify_gradle $PLATFORM_DIR/'build.gradle', ENV['FABRIC_API_KEY'], ENV['FABRIC_BUILD_SECRET']
