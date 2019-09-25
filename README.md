# ipa-parse

Console utility for extracting some useful information from .ipa files, for example app icon image and provisioning profile description.

Build
```shell
$ make release
```

Run
```shell
$ ipa-parse /path/to/file.ipa
```

Result
```json
{
  "uuid" : "4101A015-EAE3-452E-8AD6-83FDB316C32E",
  "fileName" : "App-Store.ipa",
  "size" : 2635183,
  "provisioningProfile" : {
    "teamIdentifier" : [
      "42LRQS6X44"
    ],
    "expirationDate" : "2020-09-23T10:56:58+0300",
    "creationDate" : "2019-09-24T10:56:58+0300",
    "profileType" : "iOS Enterprise",
    "developerCertificates" : [
      {
        "summary" : "iPhone Distribution: Redmadrobot OOO",
        "organizationName" : "Redmadrobot OOO"
      }
    ],
    "appIDName" : "Test Sigh",
    "name" : "TestSigh Distribution"
  },
  "icon" : {
    "base64Data" : "...",
    "type" : "image\/png",
    "name" : "AppIcon60x60.png"
  },
  "date" : "2019-09-25T12:49:50+0300"
}
```