#!/usr/bin/env ruby

require 'xcodeproj'

$PLATFORM_DIR = Pathname.pwd.realpath/'platforms'/'ios'

project = Xcodeproj::Project.open(Pathname.glob($PLATFORM_DIR/'*.xcodeproj').first)

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
