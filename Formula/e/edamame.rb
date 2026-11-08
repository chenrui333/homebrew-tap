class Edamame < Formula
  desc "Terminal Markdown editor that stays rendered while you edit"
  homepage "https://github.com/mijowi/edamame"
  url "https://github.com/mijowi/edamame/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "952c8972d2b272876f2f45a5ca83dd3d686dc8bc7655270d823402ae4634f515"
  license all_of: ["Apache-2.0", "OFL-1.1"]
  head "https://github.com/mijowi/edamame.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "src/assets/katex/OFL.txt", "src/assets/katex/FONT_NOTICE.txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/edamame --version")
    (testpath/"old.md").write("# Homebrew\n\nMarkdown editing.\n")
    cp testpath/"old.md", testpath/"new.md"
    assert_match "has no differences to review", shell_output("#{bin}/edamame --diff old.md new.md 2>&1")
  end
end
