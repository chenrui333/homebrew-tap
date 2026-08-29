class IamCollect < Formula
  desc "Collect IAM information from all your AWS organization, accounts, and resources"
  homepage "https://github.com/cloud-copilot/iam-collect"
  url "https://registry.npmjs.org/@cloud-copilot/iam-collect/-/iam-collect-0.1.214.tgz"
  sha256 "f204765a4cd1352eff2cb5d9c9f73111aef6642d41553013cea6ada751bbcffe"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "9e7f078df383302037eb69052b2531e7c0db92f03f733c8c23f5d6e23a4e57e7"
  end

  depends_on "node"

  # Preserve npm's env shebangs so the JavaScript payload stays platform-independent.
  skip_clean "libexec"

  def install
    system "npm", "install", *std_npm_args
    # npm tarballs ship a stale generated version file; align CLI output with package.json.
    version_regexp = /IAM_COLLECT_VERSION = '[^']+';/
    inreplace libexec/"lib/node_modules/@cloud-copilot/iam-collect/dist/cjs/config/version.js",
              version_regexp, "IAM_COLLECT_VERSION = '#{version}';"
    inreplace libexec/"lib/node_modules/@cloud-copilot/iam-collect/dist/esm/config/version.js",
              version_regexp, "IAM_COLLECT_VERSION = '#{version}';"
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iam-collect --version")

    system bin/"iam-collect", "init"
    assert_path_exists testpath/"iam-collect.jsonc"

    assert_match "Could not load credentials from any providers", shell_output("#{bin}/iam-collect download 2>&1", 1)
  end
end
