class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.31.0.tgz"
  sha256 "3d16970155db82cd40973032b86b9d8f40b67da29f0ac665138d240b2b6e80b4"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ffb66c3fb445bb19483bcd8be494cec1e7c4d9de5df159a83452da153d5b0709"
    sha256 cellar: :any,                 arm64_sequoia: "ffb66c3fb445bb19483bcd8be494cec1e7c4d9de5df159a83452da153d5b0709"
    sha256 cellar: :any,                 arm64_sonoma:  "ffb66c3fb445bb19483bcd8be494cec1e7c4d9de5df159a83452da153d5b0709"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae9a0b489b512be4cb4db916ec5cdd33e61ef6cff62f4b43f6bc3673ae00e6e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "840e9fd68cb48495c22c019b0fc23e9f2ecff4cbf557b14d9fe56ab4c8ee62ce"
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
