class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.68.0.tgz"
  sha256 "0f23bed561dec385ca560483fa9896991b9ff21d654d14b81a0d7031a1739aef"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "bf6a5311f6502e4fb507a7fa46c3f1cc2646cd9d59d423f2d98dd9bc567d4c43"
    sha256 cellar: :any,                 arm64_sequoia: "38c1969808457cba5ae14b20c427a84ae1a31b49845c5afe2c431321f0fb984a"
    sha256 cellar: :any,                 arm64_sonoma:  "38c1969808457cba5ae14b20c427a84ae1a31b49845c5afe2c431321f0fb984a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7432582c18dedc7d403d7ef5a69ec4408f5ebe8df996614a333f394d2186b8ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2be1daf5f8a646bc56e44649eb7528cf9d772e94d50749881b8065d21ca37ef7"
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
