class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.76.2.tgz"
  sha256 "92e5bf24ab0d50db2621426117d1a721423e806248cdba80503df52051df655a"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "06093966d43a1030afc028bf213a01f875f41e66c077b090ed3e0e3271655e2c"
    sha256 cellar: :any,                 arm64_sequoia: "2390db6f547e20d46c18f6310e40b23f073a5b2f634f60f6587afd2b087cb99e"
    sha256 cellar: :any,                 arm64_sonoma:  "2390db6f547e20d46c18f6310e40b23f073a5b2f634f60f6587afd2b087cb99e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "425067e68da1ef69b18e54e886c3e46c0d3ddf30665e0d66425c62ee1e91fd7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "082899e9ec3d97c196718203c6a831a26bb1156be64963289f85acbcc6b6eeb6"
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
