class Gitv < Formula
  desc "Terminal-based viewer for GitHub issues"
  homepage "https://github.com/JayanAXHF/gitv"
  url "https://github.com/JayanAXHF/gitv/archive/refs/tags/gitv-tui-v0.4.2.tar.gz"
  sha256 "d1f0c826e56c8595ecfc6e7c8be8461ea9a9cced3ad1b0abd61ae60a565a0398"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/JayanAXHF/gitv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6235b970173eb61697bbb3261d6ea2d7c15875cb76b57827311e18ef3f347ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aacfac0de41fee8ec137bcf0320667ee6e2555182ae135d2866c02726ab5a1a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59f0df09cfbd889d172a2a973a439cc2a3b80919a99575afefafb9a514bb0eaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22767a862095b2ffb1406c6abd5e3fa3ec6426c99ac522d2342f80090be431d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d93ab25fd9c9cebeaed669e25b7ceacc01d5b7232672d85a98e28a1d597d638"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    ENV["PREFIX"] = prefix
    system bin/"gitv", "--generate-man"

    generated_manpage = man1/"gitv_tui.1"
    generated_manpage.rename(man1/"gitv.1") if generated_manpage.exist?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitv --version")
    assert_match "Log directory:", shell_output("#{bin}/gitv --print-log-dir")

    ENV["PREFIX"] = testpath.to_s
    output = shell_output("#{bin}/gitv --generate-man")
    assert_match "Installed manpages:", output
    assert_path_exists testpath/"share/man/man1/gitv_tui.1"
  end
end
