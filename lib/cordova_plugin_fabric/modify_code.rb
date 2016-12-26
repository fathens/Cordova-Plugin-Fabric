
module Fabric
    def self.modify_line(target_file, replacements)
        file_tmp = "#{target_file}.tmp"
        File.open(target_file, 'r') { |src|
            File.open(file_tmp, 'w') { |dst|
                src.each_line { |line|
                    addings = replacements.map { |regex, news|
                        news if line =~ regex
                    }.compact.flatten
                    dst.puts(addings.empty? ? line : addings)
                }
            }
        }
        File.rename file_tmp, target_file
    end
end
