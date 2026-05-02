class BicepLsp < Formula
  desc "Declarative language for describing and deploying Azure resources"
  homepage "https://github.com/Azure/bicep"
  url "https://github.com/Azure/bicep/archive/refs/tags/v0.33.93.tar.gz"
  sha256 "f2c9edd072d87df25a0f5392307c94e577c97c1523ffa6e2fdeb8d709fed1c40"
  license "MIT"

  depends_on "dotnet@8"

  def install
    sdk_version = Utils.safe_popen_read("#{Formula["dotnet@8"].opt_bin}/dotnet", "--list-sdks").lines.first.split.first.strip
    inreplace "global.json", "\"8.0.405\"", "\"#{sdk_version}\""

    # Disable .NET analyzers
    inreplace "src/Directory.Build.props",
              "<EnableNETAnalyzers>true</EnableNETAnalyzers>",
              "<EnableNETAnalyzers>false</EnableNETAnalyzers>"

    # Remove the problematic analyzer reference
    inreplace "src/Bicep.Core/Bicep.Core.csproj",
              /<PackageReference Include="Azure\.Bicep\.Internal\.RoslynAnalyzers"[^>]+\/>/,
              ""

    rm_rf "src/Bicep.Core/Analyzers"

    dotnet = Formula["dotnet@8"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
      -p:Version=#{version}
    ]

    system "dotnet", "publish", "src/Bicep.Cli", *args
    bin.install_symlink libexec/"Bicep" => "bicep"
  end

  test do
  end
end
