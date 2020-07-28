#!/bin/bash

# Adapted from http://stackoverflow.com/questions/24039470/xcode-6-ios-creating-a-cocoa-touch-framework-architectures-issues/26691080#26691080
# and https://gist.github.com/cromandini/1a9c4aeab27ca84f5d79

# Create a new aggregate target.
# For the automatically generated scheme, change its build config to "release".
# Ensure this target's "product name" build setting matches the framework's.
# Add a run script with `source "${PROJECT_DIR}/path_to_this_script`
PROJECT_NAME="FiskalySDK"
PRODUCT_NAME="FiskalySDK"
CONFIGURATION=FISKALY-SDK
UNIVERSAL_OUTPUT_DIR=${PWD}/${CONFIGURATION}-universal
RELEASE_DIR=${PWD}/Build/FiskalySDK.framework

# make sure the output directory exists
mkdir -p "${UNIVERSAL_OUTPUT_DIR}"

# Step 1. Build Device and Simulator versions
xcodebuild clean build -project FiskalySDK.xcodeproj -scheme FiskalySDK -configuration Release -destination generic/platform=iOS CONFIGURATION_BUILD_DIR=${PWD}/Build/iOS
xcodebuild clean build -project FiskalySDK.xcodeproj -scheme FiskalySDK -configuration Release -destination generic/platform='iOS Simulator' CONFIGURATION_BUILD_DIR=${PWD}/Build/Simulator

# Step 2. Copy the framework structure (from iphoneos build) to the universal folder
cp -R "${PWD}/Build/iOS/${PRODUCT_NAME}.framework" "${UNIVERSAL_OUTPUT_DIR}/"

# Step 3. Copy Swift modules from iphonesimulator build (if it exists) to the copied framework directory
SIMULATOR_SWIFT_MODULES_DIR="${PWD}/Build/Simulator/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule/"
echo ${SIMULATOR_SWIFT_MODULES_DIR}
if [ -d "${SIMULATOR_SWIFT_MODULES_DIR}" ]; then
    echo "GOT HERE"
    cp -R "${SIMULATOR_SWIFT_MODULES_DIR}." "${UNIVERSAL_OUTPUT_DIR}/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule"
fi

# Step 4. Create universal binary file using lipo and place the combined executable in the copied framework directory
lipo -create -output "${UNIVERSAL_OUTPUT_DIR}/${PRODUCT_NAME}.framework/${PRODUCT_NAME}" "${PWD}/Build/Simulator/${PRODUCT_NAME}.framework/${PRODUCT_NAME}" "${PWD}/Build/iOS/${PRODUCT_NAME}.framework/${PRODUCT_NAME}"

# Step 5. Convenience step to copy the framework to the project's directory
cp -R "${UNIVERSAL_OUTPUT_DIR}/${PRODUCT_NAME}.framework" "${RELEASE_DIR}"

# Step 6. Convenience step to open the project's directory in Finder
cp license.txt ${UNIVERSAL_OUTPUT_DIR}
cd ${UNIVERSAL_OUTPUT_DIR}
zip -r FiskalySDK.zip FiskalySDK.framework license.txt
cp FiskalySDK.zip ../
rm -rf ../Build
rm -rf ${UNIVERSAL_OUTPUT_DIR}