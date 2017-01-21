import Foundation

@objc(FabricBase)
class FabricBase: CDVPlugin {
    override func pluginInitialize() {
        Fabric.with([
            // Kits
        ])
    }
}
