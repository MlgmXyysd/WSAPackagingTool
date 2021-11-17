# WSAPackagingTool

**WIP Project**

Allows you to modify WSA's Msixbundle and distribute it.

## Requirements
- Windows 10+
- Windows Software Development Kit (The required tools have been built in. For more details, see [libraries](libraries/README.md).)
- Git for Windows (ditto)
- Powershell 6+ (Unpack supports Powershell 5.1+, Install needs Powershell 5.1 to work.)

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
- [ ] Libraries: Add multi architecture from WDK.
- [ ] Repack: Better way to generate installation utility instead of using Git Split.

## Changelog
- 1.0:
	- First ver

## Credits
- [MlgmXyysd](https://github.com/MlgmXyysd)
- [XiaoMengXinX](https://github.com/XiaomengxinX)

## License
No license during WIP. All rights are reserved.
