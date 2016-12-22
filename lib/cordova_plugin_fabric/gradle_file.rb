require 'pathname'

def modify_gradle(target_file, api_key, api_secret)
    File.open(target_file.dirname/'fabric.properties', 'w') { |dst|
        dst.puts "apiKey=#{api_key}"
        dst.puts "apiSecret=#{api_secret}"
    }

    log_header "Rewriting #{target_file}"
    file_tmp = "#{target_file}.tmp"

    plugin = true
    classpath = true

    File.open(target_file, 'r') { |src|
        File.open(file_tmp, 'w') { |dst|
            src.each_line { |line|
                dst.puts line
                add_line = lambda { |text|
                    dst.puts "#{line.match(/^[\s]*/)[0]}#{text}"
                }
                if line =~ /^\s*mavenCentral()/
                    add_line.call "maven { url 'https://maven.fabric.io/public' }"
                end
                if plugin && line =~ /apply plugin:/
                    add_line.call "apply plugin: 'io.fabric'"
                    plugin = false
                end
                if classpath && line =~ /classpath 'com\.android\.tools\.build:gradle:/
                    add_line.call "classpath 'io.fabric.tools:gradle:1.+'"
                    classpath = false
                end
            }
        }
    }
    File.rename(file_tmp, target_file)
end
