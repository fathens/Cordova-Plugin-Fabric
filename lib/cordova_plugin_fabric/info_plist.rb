require 'rexml/document'

module Fabric
    class InfoPlist
        def initialize(plist_file)
            @original_file = plist_file
            @xml = REXML::Document.new(File.open(plist_file))
        end

        def write(target_file = nil)
            target_file ||= @original_file
            File.open(target_file, 'w') { |dst|
                @xml.write(dst)
            }
        end

        def add_kit(kit)
            root_dict = REXML::Element.new("dict", kits_array)
            REXML::Element.new("key", root_dict).text = "KitName"
            REXML::Element.new("string", root_dict).text = kit.name
            REXML::Element.new("key", root_dict).text = "KitInfo"
            info_dict = REXML::Element.new("dict", root_dict)
            kit.infos.each { |info|
                REXML::Element.new("key", info_dict).text = info.attributes['key']
                REXML::Element.new(info.attributes['type'], info_dict).text = info.text.gsub(/\$\{(.+?)\}/) {
                    ENV[$1] || $1
                }
            }
        end

        private

        def kits_array
            @kits_array ||= begin
                fabric = @xml.get_elements('//key[.="Fabric"]').first
                fabric.next_element.get_elements('key[.="Kits"]').first.next_element
            end
        end
    end
end
