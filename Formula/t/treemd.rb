class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "996e17df2e361f1b11cd626d210d6e820aa8c9c38c09d5d09e8b00dbdcc81abf"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "033024978540aad3bb8c3a998666aafaa0c3117754b86981ed51d7aca50eb352"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "342394a6475b9a0e8f1a70005852a525c12cbfa8d9578a6c283a2bb804f20a49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "984e607d0e7fe52bdf126fa980325f935aaa9d2fec5eabb6e330d4b44fee9285"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8adb1669ad6c8a13b76135521c151b785b69bd229ea5b8b8aff743cff66b4ae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28dfff8f474983c41a46996055ba7918e1276ae7f7197e6123d37f3aa178e2af"
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
