#!/usr/bin/env ruby

require_relative '../../../lib/cordova_plugin_fabric'

$PROJECT_DIR = Pathname.pwd.realpath
$PLATFORM_DIR = $PROJECT_DIR/'platforms'/'ios'

plist = Fabric::InfoPlist.new Pathname.glob($PLATFORM_DIR/'*'/'*-Info.plist').first
Fabric::Kits.new('ios', $PROJECT_DIR).each { |kit|
    plist.add_kit kit
}
plist.write
