#!/bin/sh

TAG="0.6.0";
SWIFT_VERSION="swift-DEVELOPMENT-SNAPSHOT-2016-06-20-a";

XCODE=`xcrun --version`

if [[ $XCODE != *"xcrun version 30."* ]];
then
	echo "Xcode 8 must be installed and selected.";
	echo "Install Xcode 8: https://developer.apple.com/download/"
	echo "Select Xcode 8: sudo xcode-select -s /Applications/Xcode-beta.app/";
	exit 1;
fi

SWIFT=`which swift`;

if [[ $SWIFT == *"swiftenv"* ]];
then
	echo "Swiftenv installed, continuing...";
	swiftenv install $SWIFT_VERSION;
else
	if [[ $SWIFT == *"swift-latest.xctoolchain"* ]];
	then
		LTALIAS=`ls -lah /Library/Developer/Toolchains/swift-latest.xctoolchain`;
		if [[ $LTALIAS == *$SWIFT_VERSION* ]];
		then
			echo "$SWIFT_VERSION installed, continuing...";
		else
			echo "Incorrect Swift version installed, please install $SWIFT_VERSION";
			exit 1;
		fi
	else
		if [[ $SWIFT == *$SWIFT_VERSION* ]];
		then
			echo "$SWIFT_VERSION installed, continuing...";
		else
			echo "Neither Swift nor Swiftenv is installed";
			echo "Please review the documentation for installing the Toolbox at http://docs.qutheory.io";
			exit 1;
		fi
	fi
fi

DIR=".vapor-toolbox-$TAG";

rm -rf $DIR;

mkdir -p $DIR
cd $DIR;

git clone https://github.com/qutheory/vapor-toolbox
cd vapor-toolbox
git checkout $TAG

swift build -c release;
.build/release/Executable self install;

cd ../../;
rm -rf $DIR;

echo 'Use vapor --help and vapor <command> --help to learn more.';
