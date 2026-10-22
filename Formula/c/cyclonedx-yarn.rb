class CyclonedxYarn < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Yarn projects"
  homepage "https://github.com/CycloneDX/cyclonedx-node-yarn"
  url "https://github.com/CycloneDX/cyclonedx-node-yarn/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "f80e6ace4be86bf929caa6094fd19adb9e2ffe714aa26d756a5884d1d55204c0"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-node-yarn.git", branch: "main"

  depends_on "corepack" => [:build, :test] # for the yarn 4 pinned by `packageManager`
  depends_on "node"

  resource "homebrew-package.json", :test do
    url "https://raw.githubusercontent.com/CycloneDX/cyclonedx-node-yarn/45c94758223f54b961798cd3c902c710f53dd4df/tests/_data/testbeds/lockfile-only/package.json"
    sha256 "4b8feb7d4fd2ecf4abe415cb1579fa53574cf6f8bafecd9f3437ad7ba07d627e"
  end

  resource "homebrew-yarn.lock", :test do
    url "https://raw.githubusercontent.com/CycloneDX/cyclonedx-node-yarn/45c94758223f54b961798cd3c902c710f53dd4df/tests/_data/testbeds/lockfile-only/yarn.lock"
    sha256 "baf2ad0cdc88073cc1d5be9b3badad9028bac31db058575851aee236871713c7"
  end

  # The test needs corepack to download the yarn pinned by the fixture
  allow_network_access! :test

  def fetch
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"
    # `--mode=skip-build` skips compiling the test-only `libxmljs2` native addon
    system "yarn", "install", "--immutable", "--mode=skip-build"
  end

  def install
    system "yarn", "build:gbti"
    system "yarn", "build:bundle"

    # The npm package's layout, where the CLI looks for the plugin first
    libexec.install "bin", "bundles/@yarnpkg/plugin-cyclonedx.js" => "yarn-plugin-cyclonedx.cjs"
    bin.install_symlink libexec/"bin/cyclonedx-yarn-cli.js" => "cyclonedx-yarn"
  end

  def caveats
    <<~EOS
      cyclonedx-yarn needs Yarn 4 or newer on your PATH, for example from:
        brew install corepack
    EOS
  end

  test do
    testpath.install resource("homebrew-package.json"), resource("homebrew-yarn.lock")
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"
    ENV["YARN_ENABLE_NETWORK"] = "0"

    assert_match version.to_s, shell_output("#{bin}/cyclonedx-yarn --version")

    system bin/"cyclonedx-yarn", "--lockfile-only", "--output-file", "sbom.json"
    assert_match "pkg:npm/is-positive@3.1.0", (testpath/"sbom.json").read
  end
end
