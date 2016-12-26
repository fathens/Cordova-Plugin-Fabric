require 'pathname'
require 'rexml/document'

module Fabric
    class Kits
        def initialize(platform_name, base_dir)
            @kits = Pathname.glob(base_dir/'plugins'/'*'/'plugin.xml').map { |pluginxml|
                begin
                    xml = REXML::Document.new(File.open(pluginxml))
                    xml.get_elements("//platform[@name='#{platform_name}']/fabric").map { |e|
                        Kit.new e
                    }
                rescue => ex
                    puts "Error on '#{pluginxml}': #{ex.message}"
                end
            }.compact.flatten
        end

        def imports
            @imports ||= @kits.map { |kit| kit.imports }.flatten.uniq
        end

        def instances
            @instances ||= @kits.map { |kit| kit.instances }.flatten.uniq
        end
        end
    end

    class Kit
        def initialize(element)
            @element = element
        end

        def imports
            @imports ||= @element.get_elements('import').map(&:text).compact.map { |t|
                "import #{t}"
            }
        end

        def instances
            @instances ||= @element.get_elements('instance').map(&:text).compact
        end
    end
end
