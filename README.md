![GitHub forks][github-forks]
![GitHub Repo stars][github-stars]
![GitHub contributors][github-contributors]
![GitHub][github-license]
[![NuGet][nuget-badge]][nuget-package]

## About

NfpmTool is a repackaging of [nFPM][nfpm-site] (the deb, rpm, apk, ipk, and arch linux packager) as a
[Dotnet tool][dotnet-tools].

nFPM is already available in numerous formats for [installation][nfpm-download].
Packaging it as a Dotnet tool allows for multiple versions to be installed and cached on a system
simultaneously, and users can control which version is used through a
[Dotnet tool manifest file][dotnet-manifest].

## Installation & Usage

The following will add NfpmTool to a Dotnet tool manifest file:

```bash
dotnet new tool-manifest # if you are setting up this repo
dotnet tool install --local SamSarette.NfpmTool
```

The tool can then be executed by:

```bash
dotnet nfpm <arguments>
```

## Platform Support

NfpmTool bundles native nFPM executables for:

- Linux (x64, arm64)
- Windows (x64, arm64)

## Contributing

Contributions are welcome! Please see our [Contributing Guide][contributing] for details.

## Code of Conduct

This project has adopted a [Code of Conduct][code-of-conduct] that we expect participants to adhere to.

## Security

For information about reporting security vulnerabilities, please see our [Security Policy][security].

## License

This project is licensed under the MIT License - see the [LICENSE][license] file for details.

[github-forks]: https://img.shields.io/github/forks/lunarcloud/NfpmTool?style=plastic
[github-stars]: https://img.shields.io/github/stars/lunarcloud/NfpmTool?style=plastic
[github-contributors]: https://img.shields.io/github/contributors/lunarcloud/NfpmTool?style=plastic
[github-license]: https://img.shields.io/github/license/lunarcloud/NfpmTool?style=plastic
[nuget-badge]: https://img.shields.io/nuget/v/SamSarette.NfpmTool?style=plastic&logo=nuget
[nuget-package]: https://www.nuget.org/packages/SamSarette.NfpmTool
[nfpm-site]: https://nfpm.goreleaser.com/
[nfpm-download]: https://github.com/goreleaser/nfpm/releases
[dotnet-tools]: https://learn.microsoft.com/en-us/dotnet/core/tools/global-tools
[dotnet-manifest]: https://learn.microsoft.com/en-us/dotnet/core/tools/global-tools#install-a-local-tool
[contributing]: https://github.com/lunarcloud/NfpmTool/blob/main/CONTRIBUTING.md
[code-of-conduct]: https://github.com/lunarcloud/NfpmTool/blob/main/CODE_OF_CONDUCT.md
[security]: https://github.com/lunarcloud/NfpmTool/blob/main/SECURITY.md
[license]: https://github.com/lunarcloud/NfpmTool/blob/main/LICENSE
