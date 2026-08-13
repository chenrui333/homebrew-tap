class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://github.com/clidey/dory"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-1.0.3.tgz"
  sha256 "69928f807c100ef4fd7c4d2d0a33c116ad76c31d749886ef63ce930d4d645f7b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "962e92afa3e5798eb98d8680856e0879587fb2bbbf1189b4cdfcfe5ecd7f12d7"
    sha256 cellar: :any,                 arm64_sequoia: "962e92afa3e5798eb98d8680856e0879587fb2bbbf1189b4cdfcfe5ecd7f12d7"
    sha256 cellar: :any,                 arm64_sonoma:  "962e92afa3e5798eb98d8680856e0879587fb2bbbf1189b4cdfcfe5ecd7f12d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7a9e8ad72680ccc050f88a6ce372b7d959691b58087fa11f0c7132e656a2768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e66c30f1c1cd7ac315c29295df21dee70ed3f9fe2c6ba815b2e8d22b3b29263f"
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
