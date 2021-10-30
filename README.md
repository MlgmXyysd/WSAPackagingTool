# WSAPackagingTool

**WIP Project**

Allows you to unpack WSA's Msixbundle and distribute it after packaging.

## Requirements

- Windows 10+
- Windows Software Development Kit (The required tools have been built in. For details, see [libraries](libraries/README.md).)
- Powershell 6+ (Unpack requires Powershell 5.1+, Install needs Powershell 5.1 to work.)

## How to use

1. Drag WSA Msixbundle to unpack.cmd (or use `unpack <msixbundle>` command) to unpack.
2. Feel free modify package in `temp` folder. (Such as GappsScript or MagiskScript, or you can do something cooler.)
3. Run repack.cmd.
4. The `WSA.cer`, `*_repack.msixbundle` and `install.cmd` is the out file.

## How to install

- Just drag msixbundle file to `install.cmd` (or use `install <msixbundle>` command).
- Make sure that there is no old version of WSA.

## Feedback
- Telegram: [@WSA_Community](https://t.me/wsa_community)
- GitHub: [Issues](https://github.com/WSA-Community/WSAPackageTool/issues)

## TO-DOs

- [ ] Unpack: Automatically identify Msix and Msixbundle.
- [ ] Unpack: Unpack all sub Msix in the manifest.
- [x] Repack: Automatically generate cer certificate. (Require Powershell 6.1+)
- [ ] Repack: Integrate certificate with install.cmd.
- [x] Repack: Store certificates in `libraries` to keep the home path clean.
- [x] Repack: Move output stuffs to `out` folder.
- [x] Install: Detect and process installed previous versions. (It's not just uninstallation)
- [ ] Libraries: Add multi architecture from WDK.

## Changelog
- 1.0:
	- First ver

## Workaround
- Nah, too lazy to write for the time being.

## References
- Nah, too lazy to write for the time being.

## Credits
- [MlgmXyysd](https://github.com/MlgmXyysd)
- [XiaoMengXinX](https://github.com/XiaomengxinX)

## License

No license during WIP. All rights are reserved.

