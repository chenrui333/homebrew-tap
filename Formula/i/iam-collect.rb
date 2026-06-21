class IamCollect < Formula
  desc "Collect IAM information from all your AWS organization, accounts, and resources"
  homepage "https://github.com/cloud-copilot/iam-collect"
  url "https://registry.npmjs.org/@cloud-copilot/iam-collect/-/iam-collect-0.1.197.tgz"
  sha256 "7e2b30aef30cb5d0ab43cd0b54f6857d477db8d7d8d75f647278b0294ff6798e"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "34377bbe70747f6b0321814b002da3d959b338d2774ebf8b38a467b0e1a35f57"
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
