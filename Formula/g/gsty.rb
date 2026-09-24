class Gsty < Formula
  desc "Browse and apply Ghostty themes"
  homepage "https://github.com/tappunk/gsty"
  url "https://github.com/tappunk/gsty/archive/refs/tags/v0.1.19.tar.gz"
  sha256 "baa2f0a7b4e6c12c26f39c6418561039b96719a9d3f542befdc3c08f5095c11c"
  license "MIT"
  head "https://github.com/tappunk/gsty.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73d79d8900044ecb77f6f67accbc5bb5f718170d94f139cccfe72f72f9745b60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "230f44e8e9bd9fccaab154e790802a9571198b1183520e63969b1c662a446570"
    sha256 cellar: :any,                 arm64_linux:   "8c6f53ea5e59d02916bae1cb0baad486a352af9119badc318f1f926cefcc53b2"
    sha256 cellar: :any,                 x86_64_linux:  "e81fc9a43d2f4d5fccc9dbf33c35f041b4f8cd73dc83c17a1ae4c9ad46948e37"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsty --version")
    (testpath/".config/ghostty/themes/brew-test").write("background = #000000\nforeground = #ffffff\n")
    assert_match "brew-test", shell_output("#{bin}/gsty --list")
  end
end
