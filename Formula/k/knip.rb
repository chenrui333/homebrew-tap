class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.47.0.tgz"
  sha256 "0662fa3bf5f113d9daa4ac31ea062c5f9d49a39cddf8517df17e239412f6bba8"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "109b83c9e6264a83a3240881f2b7c06f4080e31c5f028955df61d27ae17a6d42"
    sha256 cellar: :any,                 arm64_sequoia: "109b83c9e6264a83a3240881f2b7c06f4080e31c5f028955df61d27ae17a6d42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff5e6330bf6cd1c4435677842f7202038ed7db86afce48b8d7496d23771671af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d03a640a71d10e15146e58c42265bece79003e98d050437f51b20b3813f5ede9"
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
