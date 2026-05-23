class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.14.2.tgz"
  sha256 "a94cfb77661473cc0d77007bf91f430f78ec4f231caba2c028aa87e41939b38f"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2122295278f848bb6a0045590f2d52afe8b5b23503023968bfc9b929e92d05d1"
    sha256 cellar: :any,                 arm64_sequoia: "4cf4cf8e3d9f1bdcbdecc1a4c634a2135d17e2086a7bd866146a57b7099669cd"
    sha256 cellar: :any,                 arm64_sonoma:  "4cf4cf8e3d9f1bdcbdecc1a4c634a2135d17e2086a7bd866146a57b7099669cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f7c3568a5c4f1e4f18a0f54235cf5acc02e97bdf39a406541e773d7f5ce9034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6af5a982e23d58add4c6708539dbc737afda991d329857af03405b7cd0724a70"
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
