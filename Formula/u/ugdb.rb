class Ugdb < Formula
  desc "TUI for gdb"
  homepage "https://github.com/ftilde/ugdb"
  url "https://github.com/ftilde/ugdb/archive/refs/tags/0.1.12.tar.gz"
  sha256 "f3bd6d36c930dcdcd4f80d03ee1883f8312f5de04e1240ba78e990a2bec58d72"
  license "MIT"
  head "https://github.com/ftilde/ugdb.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Fails in Linux CI with `Failed to get terminal attributes: Sys(ENOTTY)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/ugdb --version")

    assert_match "Failed to spawn gdb process (\"gdb\")", shell_output("#{bin}/ugdb 2>&1", 252)
  end
end
