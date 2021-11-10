# zig-ios-example

Minimal `build.zig` for targeting iOS with Zig toolchain.

# Building

In all cases, regardless if you are cross-compiling from macOS or a different host such as Linux,
you will need to provide the appropriate Apple SDK such as `iphoneos` if targeting hardware devices
or `iphonesimulator` if targeting the simulator.

## Building on macOS

In order to install the SDK for targeting iOS, install Xcode with all components. Then, all you need to
do is specify the target. For iPhoneOS that would be

```
zig build -Dtarget=aarch64-ios
```

while for the iPhoneSimulator on an M1 Mac

```
zig build -Dtarget=aarch64-ios-simulator
```

and for the iPhoneSimulator on an Intel Mac

```
zig build -Dtarget=x86_64-ios-simulator
```

## Building on a different host such as Linux

When building on a foreign host, Zig will not autodetect the path to the SDK as it does on macOS,
so you will need to provide the path manually using the `--sysroot` flag

```
zig build --sysroot <path_to_sdk> -Dtarget=aarch64-ios-simulator
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

