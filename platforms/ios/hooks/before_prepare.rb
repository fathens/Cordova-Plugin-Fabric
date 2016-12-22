#!/usr/bin/env ruby

require 'xcodeproj'
require 'rexml/document'

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
    xml.get_elements('//podfile').each { |podfile|
        podfile.get_elements('//pod[@name="Answers"]').each { |pod|
            podfile.delete_element pod
        }
    }
    xml.write(output: File.open(pluginxml, 'w'), indent: 4)
    puts "Removed 'Answers' from pods"

    Pathname.glob(platform/'*'/'Plugins'/'org.fathens.cordova.plugin.fabric.Answers'/'**'/'*.swift').each { |file_src|
        file_tmp = "#{file_src}.tmp"
        File.open(file_src, 'r') { |src|
            File.open(file_tmp, 'w') { |dst|
                src.each_line { |line|
                    if line =~ /^import Answers$/
                        puts "Replacing import 'Answers' to 'Crashlytics'"
                        dst.puts "import Crashlytics"
                    else
                        dst.puts line
                    end
                }
            }
        }
        File.rename file_tmp, file_src
    }
end

$PROJECT_DIR = Pathname.pwd.realpath
$PLATFORM_DIR = $PROJECT_DIR/'platforms'/'ios'

add_submission $PLATFORM_DIR
remove_answers $PROJECT_DIR, $PLATFORM_DIR
