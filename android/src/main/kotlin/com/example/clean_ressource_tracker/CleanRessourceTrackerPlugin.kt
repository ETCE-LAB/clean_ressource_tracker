package com.example.clean_ressource_tracker

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** CleanRessourceTrackerPlugin */
class CleanRessourceTrackerPlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "alina.simon.measuring_ressources_plugin/cputime")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
            call: MethodCall,
            result: Result
    ) {
        if (call.method.equals("getCPUTime")) {

            val cpuTime =  android.os.Process.getElapsedCpuTime()
            if (cpuTime != -1L) {
                result.success(cpuTime)
            } else {
                result.error("UNAVAILABLE", "CPU time not available.", null)
            }


        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
