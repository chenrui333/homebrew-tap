class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.42.1.tgz"
  sha256 "c340363026ddf06713902a70686686a4c0a56630fbcc004cd146e2e7f45a24af"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "54d6ae8c0c04a45d63e1ef0e0070a88307fe423d072306e08d511f581ada7c79"
    sha256 cellar: :any,                 arm64_sequoia: "54d6ae8c0c04a45d63e1ef0e0070a88307fe423d072306e08d511f581ada7c79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a873ec9bdafe0135d213866bcc0d81e9d20c367799286ff1e6b8ce51f7bd831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e574e4682b1dce9fbfd0f5fd291dc439a25038e0566b5f5cc80aedfb4e74fa24"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "my-project",
        "scripts": {
          "knip": "knip"
        }
      }
    JSON

    assert_match version.to_s, shell_output("#{bin}/knip --version")

    system bin/"knip", "--production"
  end
end
