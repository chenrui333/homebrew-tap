class ClogCli < Formula
  desc "Generate beautiful changelogs from your Git commit history"
  homepage "https://github.com/clog-tool/clog-cli"
  url "https://static.crates.io/crates/clog-cli/clog-cli-0.10.0.crate"
  sha256 "9508313c4df5a08a63a9bb8718c2d72125f9dec0cec350532d7b770083e70a71"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d54471ab1623e8c3733f3809734e000687b3bde8b150a2a63e1e038067c8b87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f40006c4b88ec190e23a2631a51522d5572c7bf2929a4385a2e55f842c458e99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b56a61f5c80c9024c715b101a6e4f0d791146b0cc5e1742108d7521b55724e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab5c928d4874973cfbc9e840b05bc1bde4a6f55b2ce76c57b714d52a5aef59c0"
  end

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
