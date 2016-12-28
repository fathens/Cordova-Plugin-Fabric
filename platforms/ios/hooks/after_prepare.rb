#!/usr/bin/env ruby

require 'xcodeproj'
require 'rexml/document'
require_relative '../../../lib/cordova_plugin_fabric'

def add_submission(base_dir)
    project = Xcodeproj::Project.open(Pathname.glob(base_dir/'*.xcodeproj').first)

    project.targets.each { |target|
        title = 'Fabric Submission'
        found = target.shell_script_build_phases.find { |phase|
            phase.name == title
        }
        if found then
            puts "Already added '#{title}': #{project}"
        else
            phase = target.new_shell_script_build_phase(title)
            puts "Adding '#{phase}' to #{target}: #{project}"
            phase.shell_script = "./Pods/Fabric/run #{ENV['FABRIC_API_KEY']} #{ENV['FABRIC_BUILD_SECRET']}"
        end
    }

    project.save
end

def remove_answers(base_dir, platform)
    return unless (base_dir/'plugins'/'org.fathens.cordova.plugin.fabric.Crashlytics'/'plugin.xml').exist?

    pluginxml = base_dir/'plugins'/'org.fathens.cordova.plugin.fabric.Answers'/'plugin.xml'
    return unless pluginxml.exist?

    xml = REXML::Document.new(File.open(pluginxml))
    xml.get_elements('//platform[@name="ios"]/podfile').each { |podfile|
        podfile.get_elements('pod[@name="Answers"]').each { |pod|
            log "Deleting pod: #{pod}"
            podfile.delete_element pod
        }
    }
    File.open(pluginxml, 'w') { |dst|
        xml.write dst
    }

    Pathname.glob(platform/'*'/'Plugins'/'org.fathens.cordova.plugin.fabric.Answers'/'**'/'*.swift').each { |file|
        Fabric::modify_line file, {
            /^import Answers$/ => "import Crashlytics"
        }
    }
end

$PROJECT_DIR = Pathname.pwd.realpath
$PLATFORM_DIR = $PROJECT_DIR/'platforms'/'ios'

add_submission $PLATFORM_DIR
remove_answers $PROJECT_DIR, $PLATFORM_DIR

kits = Fabric::Kits.new('ios', $PROJECT_DIR)

Pathname.glob($PLATFORM_DIR/'*'/'Plugins'/'org.fathens.cordova.plugin.fabric.Base'/'FabricBase.swift').each { |file|
    Fabric::modify_line file, {
        /^\/\/\s*import\s*Kits$/ => kits.imports,
        /^\s*\/\/\s*Kits*$/ => kits.instances.join(', ')
    }
}

plist = Fabric::InfoPlist.new Pathname.glob($PLATFORM_DIR/'*'/'*-Info.plist').first
kits.each { |kit|
    plist.add_kit kit
}
plist.write
