all: xcbuild xcinstall xcrun

zig-out/lib/libmain.a:
	zig build -Dtarget=aarch64-ios-simulator

.PHONY: xcbuild
xcbuild: zig-out/lib/libmain.a
	xcodebuild -sdk iphonesimulator -arch arm64

.PHONY: xcinstall
xcinstall:
	xcrun simctl install booted build/Release-iphonesimulator/MadeWithZig.app

.PHONY: xcrun
xcrun:
	xcrun simctl launch booted com.jakubkonka.MadeWithZig

.PHONY: clean
clean:
	git clean -fdx
