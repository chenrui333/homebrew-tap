class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.31.0.tgz"
  sha256 "3d16970155db82cd40973032b86b9d8f40b67da29f0ac665138d240b2b6e80b4"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "780dcd4e8c64877eeda97a1df01c96934c3d80a4adf6d94fe73f385f1bc799e8"
    sha256 cellar: :any,                 arm64_sequoia: "780dcd4e8c64877eeda97a1df01c96934c3d80a4adf6d94fe73f385f1bc799e8"
    sha256 cellar: :any,                 arm64_sonoma:  "780dcd4e8c64877eeda97a1df01c96934c3d80a4adf6d94fe73f385f1bc799e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19a308ba231dc303b0abc1833e1543fd5a3e2355e48e67a41399ba432fafe234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "073b282e648f55cd5b9148ff2d3e74c44bb7b36c852ce9d095e1dc9b356498d6"
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
