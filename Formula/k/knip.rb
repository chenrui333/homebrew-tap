class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.44.1.tgz"
  sha256 "f25b1158aacf6564d8143129c26105771dff9c11dc4841dc5f9571e2af45e4c2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c8b3e606c231f1dafc0340241bd3272d7abd6c2fe1a72931eece5c049d62bbe3"
    sha256 cellar: :any,                 arm64_sequoia: "c8b3e606c231f1dafc0340241bd3272d7abd6c2fe1a72931eece5c049d62bbe3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d8422a5dc9d8d5fb7d4917d6e18c46af00b8ca9ba0f5f8b75f99a85e5e34fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "740f7de8da543eef92d45dba69667d41be8ceff4444c00acb474574e007c49c3"
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
