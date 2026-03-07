class Gitv < Formula
  desc "Terminal-based viewer for GitHub issues"
  homepage "https://github.com/JayanAXHF/gitv"
  url "https://github.com/JayanAXHF/gitv/archive/refs/tags/gitv-tui-v0.3.3.tar.gz"
  sha256 "0ba26f072d877b3a2c9add8a84c7d70f61255bb8c64933faba8996ed5c0e00f3"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/JayanAXHF/gitv.git", branch: "main"

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
