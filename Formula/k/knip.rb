class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.61.2.tgz"
  sha256 "1c31f1b783204f08f35344e4b5cc2c9c66402fb557acf8dc24079cd552ddf3c3"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "184726dad852e4d18aa244c27e0086bf5ffefc9475f079845b8b456548c3e2f2"
    sha256 cellar: :any,                 arm64_sonoma:  "db5c279ac069f101140f1143e7166424853bf4bd3ae617b7baae9809ee218e01"
    sha256 cellar: :any,                 ventura:       "c0b149e58d4ca246a5745ef9e1ed93a289a3897db17b5a0cc25e321d6465b800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9990c7f28581f74a3f3e6168087ff28e54fe5317d9e9b9f9f0c2652a45fbac70"
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
