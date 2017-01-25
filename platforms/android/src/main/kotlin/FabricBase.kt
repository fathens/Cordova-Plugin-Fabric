package org.fathens.cordova.plugin.fabric

import android.content.pm.PackageManager
import org.apache.cordova.CordovaPlugin
import io.fabric.sdk.android.Fabric
// import Kits

public class FabricBase : CordovaPlugin() {
    override fun pluginInitialize() {
        cordova.threadPool.execute {
            val metaData = cordova.activity.packageManager.getApplicationInfo(cordova.activity.packageName, PackageManager.GET_META_DATA).metaData
            Fabric.with(cordova.activity.applicationContext,
                // Kits
            )
        }
    }
}
