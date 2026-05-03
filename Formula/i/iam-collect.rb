class IamCollect < Formula
  desc "Collect IAM information from all your AWS organization, accounts, and resources"
  homepage "https://github.com/cloud-copilot/iam-collect"
  url "https://registry.npmjs.org/@cloud-copilot/iam-collect/-/iam-collect-0.1.190.tgz"
  sha256 "539bd8549067ea5b69673550aa9410351ed2f5caff562ad6d821b2646b946400"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "39e5b9c57fb11cbc696f64a857d7760007dfe5c578aa7d613363d1ca1ca0cf7f"
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
