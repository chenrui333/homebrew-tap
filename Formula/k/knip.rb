class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.61.0.tgz"
  sha256 "9769594ad0812e3ea68f3b269c27045e9064097da62f6fa592b7319ef0e9a846"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "a215ad69e34bab3eb394f0af1d43c664255e6a2b92f4a30fc6459bf48f027b25"
    sha256 cellar: :any,                 arm64_sonoma:  "5f368e1fa58e64bde80af73b4c8c69827e6afca9f896d83fbcad27db8e3d1232"
    sha256 cellar: :any,                 ventura:       "e98806bf382bb40bb755a1b34e24bb6a3f8e50838b8c76d37bb186d05eb26267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98a37aae2a9310939acb675e8586b5d719cc8a620454808e453c906f2c54a502"
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
