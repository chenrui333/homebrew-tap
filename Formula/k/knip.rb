class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.77.4.tgz"
  sha256 "d01602867389ec3e64df406127afe2f20bf1453733564539350e1f84e9d5adc2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "d7aba3f68923686cd50e025e28a925df64c060d1e38be6dac214b4150674f4f5"
    sha256 cellar: :any,                 arm64_sequoia: "e4e270cc71d3d2c1297c39b7a461a6b8562bf8313564ac5612b3cdadcaec37a5"
    sha256 cellar: :any,                 arm64_sonoma:  "e4e270cc71d3d2c1297c39b7a461a6b8562bf8313564ac5612b3cdadcaec37a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad594fa77ac554fc9964a72efe06c27f8a25141986c49bcf05669dd1152f9297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd1c6ce1412a3095b5143ba861e7411843b027ab07a616497dfdd30d8183c57e"
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
