# zig-ios-example

Minimal `build.zig` for targeting iOS with Zig toolchain.

# Building

For iOS Simulator on Apple Silicon Mac:
```
zig build -Dtarget=aarch64-ios-simulator
```

For iOS Simulator on Intel Mac:
```
zig build -Dtarget=x86_64-ios-simulator
````


If you are building natively on macOS and have Apple SDKs installed for Apple platforms, the path
to the SDK will be autodetected for you as part of the build script. You can still manually set the
path to the SDK via `--sysroot` flag.

If you are cross-compiling from a different host such as Linux, or you don't have Apple SDKs installed
on macOS, you will need to provide the appropriate Apple SDK such as `iphoneos` if targeting hardware
devices or `iphonesimulator` if targeting the simulator. In this case, you will need to provide the path to
the SDK explicitly using the `--sysroot` flag.

Setting the sysroot looks like this

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
 
## WIP: running on an iPhone

This is more of a roadmap what I'd like the process to look like. For now, this only works for me 
locally as I am in possession of Jakub's secret sauce! However, I am working hard on making both
[`zignature`](https://github.com/kubkon/zignature) and [`zig-deploy`](https://github.com/kubkon/zig-deploy)
more complete and actually functional for others, so stay tuned for updates!

```
zig build -Dtarget=aarch64-ios.15.4...15.4
zignature -s <path-to-cert> --entitlement <path-to-entitlements.plist> zig-out/bin/MadeWithZig.app
zig-deploy -n <name-of-your-device> zig-out/bin/MadeWithZig.app
```

