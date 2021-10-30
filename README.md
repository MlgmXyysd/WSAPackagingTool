# WSAPackagingTool

**WIP Project**

Allows you to modify WSA's Msixbundle and distribute it.

## Requirements

- Windows 10+
- Windows Software Development Kit (The required tools have been built in. For more details, see [libraries](libraries/README.md).)
- Powershell 6+ (Unpack requires Powershell 5.1+, Install needs Powershell 5.1 to work.)

## How to use

1. Drag WSA Msixbundle to `unpack.cmd` (or use `unpack <msixbundle>` command) to unpack.
2. Feel free modify package in `temp` folder. (Such as GappsScript or MagiskScript, or you can do something cooler.)
3. Run `repack.cmd`.
4. The output files are in `out` folder.

## How to install

- Just drag Msixbundle file to `install.cmd` (or use `install <msixbundle>` command).

## Feedback
- Telegram: [@WSA_Community](https://t.me/wsa_community)
- GitHub: [Issues](https://github.com/WSA-Community/WSAPackageTool/issues)

## TO-DOs

- [ ] Unpack & Repack: Automatically identify Msix and Msixbundle.
- [ ] Repack: Specify output path.
- [ ] Repack: Specify output file name.
- [ ] Libraries: Add multi architecture from WDK.
- [ ] Repack: Better way to integrate certificate instead of using Git Split.
- [x] ~~Repack & Install: Integrate certificate with install.cmd.~~
- [x] ~~Unpack & Repack: Process all sub Msix in the manifest.~~
- [x] ~~Repack: Automatically generate cer certificate. (Require Powershell 6.1+)~~
- [x] ~~Repack: Store certificates in `libraries` to keep the home path clean.~~
- [x] ~~Repack: Move output stuffs to `out` folder.~~
- [x] ~~Install: Detect and process installed previous versions. (It's not just uninstallation)~~

## Changelog
- 1.0:
	- First ver

## Workaround
- Nah, too lazy to write for the time being.

## References
- https://docs.microsoft.com/en-us/powershell/module/appx/get-appxpackage
- https://docs.microsoft.com/en-us/powershell/module/appx/add-appxpackage
- https://docs.microsoft.com/en-us/powershell/module/appx/remove-appxpackage
- https://docs.microsoft.com/en-us/powershell/module/pki/export-certificate
- https://docs.microsoft.com/en-us/powershell/module/pki/export-pfxcertificate
- https://docs.microsoft.com/en-us/powershell/module/pki/new-selfsignedcertificate
- https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/get-pfxcertificate
- https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/convertto-securestring
- https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-content
- https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-childitem
- https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/test-path
- https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-item
- https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-itemproperty
- https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-itemproperty
- https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-itemproperty
- https://docs.microsoft.com/en-us/windows/msix/package/create-app-package-with-makeappx-tool
- https://docs.microsoft.com/en-us/windows/msix/package/create-certificate-package-signing
- https://docs.microsoft.com/en-us/windows/msix/package/sign-app-package-using-signtool
- https://docs.microsoft.com/en-us/uwp/schemas/bundlemanifestschema/bundle-manifest

## Credits
- [MlgmXyysd](https://github.com/MlgmXyysd)
- [XiaoMengXinX](https://github.com/XiaomengxinX)

## License

No license during WIP. All rights are reserved.

