import Foundation

@objc(FabricBase)
class FabricBase: CDVPlugin {
    override func pluginInitialize() {
        fork {
            Fabric.with([
                // Kits
            ])
        }
    }

    // MARK: - Private Utillities

    fileprivate func fork(_ proc: @escaping () -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async(execute: proc)
    }
}
