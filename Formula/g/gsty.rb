class Gsty < Formula
  desc "Browse and apply Ghostty themes"
  homepage "https://github.com/tappunk/gsty"
  url "https://github.com/tappunk/gsty/archive/refs/tags/v0.1.21.tar.gz"
  sha256 "b07c64762fff9620c62d6654709c962393e91f7dbd3c8194707a236de261fb61"
  license "MIT"
  head "https://github.com/tappunk/gsty.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "343d95ffa437258d2c8c2aacfc33c02f6edf9b166a52715064dbed4dce40c369"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9befebc10131a9aa7bcca73937e4400aa02fe12940ba3549fd4b5ebffb05cf65"
    sha256 cellar: :any,                 arm64_linux:   "0dcce94d457fdc993bbb9ca7ddd7054f1a914bd4a9b5a33e5b5aabfa962abaab"
    sha256 cellar: :any,                 x86_64_linux:  "6c839bcbe551265ae0d2b5beb6429af7239a13676cac7064f723c50aff649a8c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsty --version")
    (testpath/".config/ghostty/themes/brew-test").write("background = #000000\nforeground = #ffffff\n")
    assert_match "brew-test", shell_output("#{bin}/gsty --list")
  end
end
