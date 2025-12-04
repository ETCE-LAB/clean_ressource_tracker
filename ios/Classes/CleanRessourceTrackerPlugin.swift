import Flutter
import UIKit

public class CleanRessourceTrackerPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "alina.simon.measuring_ressources_plugin/cputime", binaryMessenger: registrar.messenger())
        let instance = CleanRessourceTrackerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getCPUTime" {
            result(getCPUTime())
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func getCPUTime() -> Int64 {
        var usage = rusage()
        let ret = getrusage(RUSAGE_SELF, &usage)
        guard ret == 0 else {
            return -1
        }

        // user CPU time in seconds + microseconds
        let userSeconds = Int64(usage.ru_utime.tv_sec)
        let userMicroseconds = Int64(usage.ru_utime.tv_usec)

        // system CPU time in seconds + microseconds
        let systemSeconds = Int64(usage.ru_stime.tv_sec)
        let systemMicroseconds = Int64(usage.ru_stime.tv_usec)

        // Ergebnis in Millisekunden wie unter Android
        let totalMicroseconds = (userSeconds + systemSeconds) * 1_000_000
            + (userMicroseconds + systemMicroseconds)

        let totalMilliseconds = totalMicroseconds / 1000
        return totalMilliseconds
    }
}