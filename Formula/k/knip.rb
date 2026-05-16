class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.14.0.tgz"
  sha256 "7834f3928fd5847fc6d29329db92d25aac7059929c1597b5e6d11a8e023b3ef2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a6894df7aaafe5afe83f8a9e4852875a74e005e2beff39b05e780519ad0ea63e"
    sha256 cellar: :any,                 arm64_sequoia: "d92a8a716c55c154ca6adce357dc4a5da87820d4767753875d0063ad6fa286db"
    sha256 cellar: :any,                 arm64_sonoma:  "d92a8a716c55c154ca6adce357dc4a5da87820d4767753875d0063ad6fa286db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f67034a43d00190fee47d879bd6c66c376dbef92fc49d638fd9ff129c637d615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdf5401ded1a2606291b3aa480e32cde0e2f291c9780cf5c27f39033570c63e7"
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
