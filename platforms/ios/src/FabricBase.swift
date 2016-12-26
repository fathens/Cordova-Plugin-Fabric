import Foundation
import Cordova
import Fabric
// import Kits

@objc(FabricBase)
class FabricBase: CDVPlugin {
    override func pluginInitialize() {
        Fabric.with([
            // Kits
        ])
    }
}
