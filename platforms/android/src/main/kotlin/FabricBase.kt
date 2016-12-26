package org.fathens.cordova.plugin.fabric

import org.apache.cordova.CordovaPlugin
import io.fabric.sdk.android.Fabric
// import Kits

public class FabricBase : CordovaPlugin() {
    override fun pluginInitialize() {
        val metaData = cordova.activity.packageManager.getApplicationInfo(cordova.activity.packageName, GET_META_DATA).metaData
        Fabric.with(cordova.activity.applicationContext,
            // Kits
        )
    }
}
