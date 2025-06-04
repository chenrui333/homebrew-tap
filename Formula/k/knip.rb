class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.60.0.tgz"
  sha256 "ab42948b5636f3f5f2c00a7d74c0af9cb7dc45e4521166ac30ec4a3920dcf9a2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "6633e28f0c88f81360de88d91d0a86557b622a3d0038780fe0b78513b12a8528"
    sha256 cellar: :any,                 arm64_sonoma:  "587ce4684af3c18f411fd9954632e34cfb7d9293855381767f8768ba1264cdad"
    sha256 cellar: :any,                 ventura:       "7e154241ff1a4f3299781680f4712138ad139676e88768d36f267a4ed1e8b9fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c3897a9badcbf1d07e84ffda28f0f9568babb4f7224fc5b441dc397c63415e3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/knip --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "my-project",
        "scripts": {
          "knip": "knip"
        }
      }
    JSON

    system bin/"knip", "--production"
  end
end
