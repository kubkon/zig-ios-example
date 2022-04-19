# zig-ios-example

Minimal `build.zig` for targeting iOS with Zig toolchain.

# Building

In all cases, regardless if you are cross-compiling from macOS or a different host such as Linux,
you will need to provide the appropriate Apple SDK such as `iphoneos` if targeting hardware devices
or `iphonesimulator` if targeting the simulator.

## Building

Regardless if you are building on macOS or Linux, etc., since you are cross-compiling to a different
platform such as `iphoneos`, Zig will _not_ autodetect the path to the SDK as it does when building natively.
(**NB this is a new change since Zig 0.9.0 release**) Therefore, you will need to provide the path explicitly
using the `--sysroot` flag

```
zig build --sysroot <path_to_sdk> -Dtarget=aarch64-ios-simulator
```

### Using xcrun to get SDK path on macOS

If you have Xcode installed with all components, you can use `xcrun` utility to automatically discover
the path to the requested SDK. For example, for iOS this would be

```
zig build --sysroot $(xcrun --sdk iphoneos --show-sdk-path) -Dtarget=aarch64-ios
```

while for the iPhoneSimulator on an M1 Mac

```
zig build --sysroot $(xcrun --sdk iphonesimulator --show-sdk-path) -Dtarget=aarch64-ios-simulator
```

and for the iPhoneSimulator on an Intel Mac

```
zig build --sysroot $(xcrun --sdk iphonesimulator --show-sdk-path) -Dtarget=x86_64-ios-simulator
```

## Running in iPhone Simulator

Fire up the simulator, and then install the app with

```
xcrun simctl install booted zig-out/bin/MadeWithZig.app
```

You can run the app with

```
xcrun simctl launch booted madewithzig
```
 
## WIP: running on an iPhone

This is more of a roadmap what I'd like the process to look like. For now, this only works for me locally as I am
in possession of Jakub's secret sauce! However, I am working hard on making both [`zignature`](https://github.com/kubkon/zignature)
and [`zig-deploy`](https://github.com/kubkon/zig-deploy) more complete and actually functional for others, so stay
tuned for updates!

```
zig build --sysroot $(xcrun --sdk iphoneos --show-sdk-path) -Dtarget=aarch64-ios.15.4...15.4
zignature -s <path-to-cert> --entitlement <path-to-entitlements.plist> zig-out/bin/MadeWithZig.app
zig-deploy -n <name-of-your-device> zig-out/bin/MadeWithZig.app
```

