# Banter iOS Development Utility Commands

# Target iOS version for simulator (can be modified as needed)
ios_version := "iOS 17.5"

# Target device pattern for simulator (can be customized, uses regex)
ios_device_pattern := "iPhone.*Pro"

# Finds a simulator UDID matching specified iOS version and device pattern
udid_for VERSION DEVICE:
    @xcrun simctl list devices available '{{VERSION}}' \
        | grep '{{DEVICE}}' \
        | sort -r \
        | head -1 \
        | awk -F '[()]' '{ print $(NF-3) }'

# Returns a platform destination string for xcodebuild commands
ios_platform:
    @echo "iOS Simulator,id=$(just udid_for '{{ios_version}}' '{{ios_device_pattern}}')"

# Runs all tests on the iOS simulator
test-client:
    #!/usr/bin/env bash
    PLATFORM_IOS=$(just ios_platform)
    xcodebuild test \
        -project Banter.xcodeproj \
        -scheme Banter \
        -destination platform="${PLATFORM_IOS}" \
        -skipMacroValidation \
    | xcbeautify

# Runs the app on the iOS simulator
run-client:
    #!/usr/bin/env bash
    PLATFORM_IOS=$(just ios_platform)
    xcodebuild run \
        -project Banter.xcodeproj \
        -scheme Banter \
        -destination platform="${PLATFORM_IOS}" \
        -skipMacroValidation \
    | xcbeautify

# Lists all available iOS simulators
list-simulators:
    xcrun simctl list devices available