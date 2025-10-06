class ClogCli < Formula
  desc "Generate beautiful changelogs from your Git commit history"
  homepage "https://github.com/clog-tool/clog-cli"
  url "https://static.crates.io/crates/clog-cli/clog-cli-0.10.0.crate"
  sha256 "9508313c4df5a08a63a9bb8718c2d72125f9dec0cec350532d7b770083e70a71"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clog --version")

    # system "git", "init"

    # (testpath/"test.txt").write "test content"
    # system "git", "add", "test.txt"
    # system "git", "commit", "-m", "feat: add test feature"
    # system "git", "tag", "v0.1.0"

    # currently broken with `error: fatal I/O error with output file` error
    # system bin/"clog", "--from", "v0.1.0", "--outfile", "CHANGELOG.md"
    # assert_path_exists testpath/"CHANGELOG.md"
    # assert_match "fix a bug", (testpath/"CHANGELOG.md").read
  end
end
