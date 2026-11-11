class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.45.0.tgz"
  sha256 "aeb34d27cc26d59eb2624fa9b570a7eaee9b63c4e6ef4e74b0724b69ed5d9b74"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6e73963891ea76439adb32d8108ecfae2f50ca9b30b64644e471b635697fec8b"
    sha256 cellar: :any,                 arm64_sequoia: "6e73963891ea76439adb32d8108ecfae2f50ca9b30b64644e471b635697fec8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c17a41418464c12ee4edcad20c22753f7f69ea241fec976b6cf62b97355e7e06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b251d128e557749a3b846885682fe6a2782ec8d6cac78e918fef7450eb53a84e"
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
