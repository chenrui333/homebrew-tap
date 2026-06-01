class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.15.0.tgz"
  sha256 "953b4c68361fb4e83a676e8bda60b6558cc23578550551cde86ee3acb034c95a"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "0ee827fe2d689497f968a33c81526ec0cb3e48f6d187db5ecd13981a7153880a"
    sha256 cellar: :any,                 arm64_sequoia: "2913e35548ec6a38b83a4647fc4a6fa95bc73ed38cde27e2e761ea0689ea2b1b"
    sha256 cellar: :any,                 arm64_sonoma:  "2913e35548ec6a38b83a4647fc4a6fa95bc73ed38cde27e2e761ea0689ea2b1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d71b03c648e7a28531d4104c9f7f64bcdd7857755a6f575abb5bb71daec25e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7586563745595f1b6745bb3a6d5f14c364a0731af638a93cd4cbaa95e3ad475e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
