require_relative 'cordova_plugin_fabric/gradle_file'
require_relative 'cordova_plugin_fabric/fabric_kits'
require_relative 'cordova_plugin_fabric/modify_code'
require_relative 'cordova_plugin_fabric/info_plist'

def log(msg)
    puts msg
end

def log_header(msg)
    log "################################"
    log "#### #{msg}"
end
