class Gsty < Formula
  desc "Browse and apply Ghostty themes"
  homepage "https://github.com/tappunk/gsty"
  url "https://github.com/tappunk/gsty/archive/refs/tags/v0.1.21.tar.gz"
  sha256 "b07c64762fff9620c62d6654709c962393e91f7dbd3c8194707a236de261fb61"
  license "MIT"
  head "https://github.com/tappunk/gsty.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baeead6c700626bc5c688f98105681d59ac8f8a92ec1a9a087fb7de7a3e06989"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b4aeed7810dec015b75ec864ea2edfcfce11109a3b664301e2f24e609c0a82f"
    sha256 cellar: :any,                 arm64_linux:   "dbc3664ee322d54ae532713ca81dc1021225c10a7373212310402aaeec8f5ca2"
    sha256 cellar: :any,                 x86_64_linux:  "d88f7c79d2ba91dffe744afa049a0a23ac82cc143d3ba0ebe7796aed50dd81f9"
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
