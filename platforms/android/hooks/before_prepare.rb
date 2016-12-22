#!/usr/bin/env ruby

require 'pathname'
require 'rexml/document'

def search_tools(base_dir)
    Pathname.glob(base_dir/'plugins'/'*'/'plugin.xml').map { |pluginxml|
        begin
            REXML::Document.new(File.open(pluginxml)).elements['//platform[@name="android"]/fabric']
        rescue => ex
            puts "Error on '#{pluginxml}': #{ex.message}"
        end
    }.compact
end

def modify_java(main_file, tools)
    return if main_file.nil? || tools.empty?

    file_tmp = "#{main_file}.tmp"

    instances = tools.map { |e| e.get_elements('//instance') }.flatten.map(&:text).compact.uniq

    File.open(main_file, 'r') { |src|
        File.open(file_tmp, 'w') { |dst|
            src.each_line { |line|
                dst.puts line
                add_line = lambda { |text|
                    dst.puts "#{line.match(/^[\s]*/)[0]}#{text}"
                }
                if line =~ /super.onCreate/
                    add_line.call "try {"
                    add_line.call "    io.fabric.sdk.android.Fabric.with(this, #{instances.join(', ')});"
                    add_line.call "} catch (Exception ex) { throw new RuntimeException(ex); }"
                end
            }
        }
    }
    File.rename(file_tmp, main_file)
end

$PROJECT_DIR = Pathname.pwd.realpath
$PLATFORM_DIR = $PROJECT_DIR/'platforms'/'android'

modify_java Pathname.glob($PLATFORM_DIR/'src'/'**'/'MainActivity.java').first, search_tools($PROJECT_DIR)
