class Mcdu < Formula
  desc "Modern disk usage analyzer and developer cleanup tool"
  homepage "https://github.com/mikalv/mcdu"
  url "https://github.com/mikalv/mcdu/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "6a6a4759a81754962d8958de64fe51eff5355188dac5b207af019cd68dcc30ca"
  license "MIT"
  head "https://github.com/mikalv/mcdu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab96ac8bcc03f76c10fb23ed8324fc93c0aaa0ed5d0300b6c402ff875c80ba80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6c859916bf476fe308fe138e3d62f0436345d7109b614328705e5bf1b3e7b34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ba55b8ea1a83eeaba83e00a8431545f31f80e007c3ee12135e10d1b3669ce8d"
    sha256 cellar: :any,                 arm64_linux:   "edbc33ef9592b1fcf8faa396636da775c66857126a1cb24e013371320663b218"
    sha256 cellar: :any,                 x86_64_linux:  "e904a9e9dd37470f1844933ee007cc0e3914cee819b2f5163d62660a8b1b0671"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mcdu")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcdu --version")
    output = shell_output("#{bin}/mcdu #{testpath}/missing 2>&1", 1)
    assert_match "Path does not exist", output
  end
end
