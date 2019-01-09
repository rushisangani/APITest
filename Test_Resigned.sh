#ipa file name
IPA="Test.ipa"

#provisioning profile
PROVISION="ProductionProfile.mobileprovision"

#certificate name - should be installed in keychain - get the name from keychain.
CERTIFICATE="iPhone Distribution: Company Name"

#name without .ipa extension
NAME="$(echo "$IPA" | cut -f 1 -d '.')"


#Start Process

#unzip
unzip -q $IPA

#remove signature
rm -rf Payload/*.app/_CodeSignature/

#embed new provisioning profile
cp $PROVISION Payload/*.app/embedded.mobileprovision

#get app entitlements from .app file
codesign -d --entitlements entitlements.xml Payload/*.app/$NAME

#code sign with new certificate and entitlement file
/usr/bin/codesign -f -s $CERTIFICATE --entitlements entitlements.xml Payload/*.app

#crate new signed ipa
zip -qr $NAME-Resigned.ipa Payload
