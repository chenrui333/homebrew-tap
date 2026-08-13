class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://github.com/clidey/dory"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-1.0.3.tgz"
  sha256 "69928f807c100ef4fd7c4d2d0a33c116ad76c31d749886ef63ce930d4d645f7b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "193bf97fd832ecc1d86dcf16bf4dcb2ccf856c051f805b9bd542fcd55449d941"
    sha256 cellar: :any,                 arm64_sequoia: "193bf97fd832ecc1d86dcf16bf4dcb2ccf856c051f805b9bd542fcd55449d941"
    sha256 cellar: :any,                 arm64_sonoma:  "193bf97fd832ecc1d86dcf16bf4dcb2ccf856c051f805b9bd542fcd55449d941"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36e5c1c9b0f928a215f05066fe080988f4d4f908d628f7dd00d684aaf27f41dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eaf0da183132a979d5a454e3b331f58165be553528294fab66dd9b9776f6264"
  end

  depends_on "node"

  def install
    # Use the source-built JavaScript implementation instead of sass-embedded's prebuilt Dart binary.
    inreplace "package.json", '"sass-embedded": "1.100.0"', '"sass": "1.100.0"'
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/dory build 2>&1", 1)
    assert_match "Dory is ready to build your docs", output
  end
end
