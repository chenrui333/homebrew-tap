class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.42.1.tgz"
  sha256 "c340363026ddf06713902a70686686a4c0a56630fbcc004cd146e2e7f45a24af"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "f0d7b523520ac7f7aba84c254f113e4d02f72d4978f6bea4816dfde5c982d74e"
    sha256 cellar: :any,                 arm64_sequoia: "f0d7b523520ac7f7aba84c254f113e4d02f72d4978f6bea4816dfde5c982d74e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8633353167d7bd0a9d0155de80f13b50c5e83604c28bb0fde0c83c4ed4b11a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c3d98d016c91be4d8e76e2012f7a744033eaccd911e3486ecea2b43bf989f14"
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
