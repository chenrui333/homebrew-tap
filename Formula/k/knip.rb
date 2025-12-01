class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.71.0.tgz"
  sha256 "bf20448e09973719365dd71148345ed2fe3cbda504eccd15aeabb5a2b9d9c5ca"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1c4d1e63883d8076ddbee2214665427c534a9ebfb3a4d77cb4b58b5dcd104f4d"
    sha256 cellar: :any,                 arm64_sequoia: "1a365fcbc106c31eea791f0112ecc535291016ce73d059b6262a53dd1f8e9d27"
    sha256 cellar: :any,                 arm64_sonoma:  "1a365fcbc106c31eea791f0112ecc535291016ce73d059b6262a53dd1f8e9d27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aace0dc2a9a3b13052df3c97f9ad61227362fcd0c788b915f3e7a8f46adbcb43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9f5b131a6c6a15a4c2830acaeb6b333f652ede26467fb4bcea415dea3b819d6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
