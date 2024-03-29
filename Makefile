project:
	swift package generate-xcodeproj --enable-code-coverage --skip-extra-files

build:
	swift build

test:
	swift test --enable-code-coverage

release:
	swift build -c release
	cp ./.build/x86_64-apple-macosx/release/ipa-parse ./ipa-parse

clean:
	swift package clean
