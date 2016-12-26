#!/usr/bin/env ruby

require 'pathname'
require_relative '../../../lib/cordova_plugin_fabric'

$PROJECT_DIR = Pathname.pwd.realpath
$PLATFORM_DIR = $PROJECT_DIR/'platforms'/'android'

kits = Fabric::Kits.new('android', $PROJECT_DIR)
Fabric::modify_line $PLATFORM_DIR/'kotlin'/'org.fathens.cordova.plugin.fabric'/'FabricBase.kt', {
    /^\/\/\s*import\s*Kits$/ => kits.imports,
    /^\s*\/\/\s*Kits\s*$/ => kits.instances.join(', ')
}
