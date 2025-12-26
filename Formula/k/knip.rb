class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.77.2.tgz"
  sha256 "f36c1aafd6d980605b5974b146eefb1822f36f82c53d82b5d829f0845d0bc43a"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ac0aa565a9c58c950d08493a967824876eab7c36caf562e6aea07cefb22eb0f1"
    sha256 cellar: :any,                 arm64_sequoia: "092d550979efe6765bc9ee05a382a04393eaaaf7cf62cb11b75d64a211b64bfe"
    sha256 cellar: :any,                 arm64_sonoma:  "092d550979efe6765bc9ee05a382a04393eaaaf7cf62cb11b75d64a211b64bfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1d9a224ff6a1f11cbcb165b2e663235f10596f7a9e131a92c78e20ff1703e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0f570163a6f0ae32bd11f172bd80fdead8657b0dd5e2b8cc4f1405c8eb740d5"
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
