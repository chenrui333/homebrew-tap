class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "24ece52c14437dd9d4b694022326b69c511f107ee0ad168bd5e7d366d8f10aa7"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d92dc42ce815f491712579ccbf180d6405dfa9920a7f01bfd4dabb549b034d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "263137bfda1bd6e8e93abcc8c95d12d2d1af2d46a12bf5855b9dbc5ad556d6ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcb2ccd78e12072f03b57e75fc9fd787b0759a2c2d94bd81323ab0f5166d9465"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e3865245e8886dff4fa715779f7203b5a34e87e80bf6f6b0bc820987b021d16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e2b16f9883dcc9c072203e943bc606802d3de39f34332cf1e36b70917b6f610"
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
