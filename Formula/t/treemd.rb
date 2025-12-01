class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "247ce8c257403eacd54b47d90dac8e05f126674569a6d63984ae11aab43048f4"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34ff6b60ffa5eb24e7134f7bfc8c0a2d31e1d3bcd6831d8bd25a6ebb3fd1879b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41d1c1c1123f1972fb352f2be9617dd2bea8ee162e5ffd623b59c0d9202e4f7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1747d6a904e0e0e412f394c155c52b074d66494ca0063e6736ef688f3dbb5bb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55ab78843d6b8cd53e8d1ec686881c459f8c8bbaa32dd85ad147b0a7b218d0b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f79afeb7416830b0d144050b0a0ac5caf78f52acfdd20117239e7ff66ab4a080"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/treemd --version")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.md").write("# Test Heading\n\nThis is a test paragraph.")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"treemd", testpath/"test.md", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "treemd - test.md - 1 headings", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
