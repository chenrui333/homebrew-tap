class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "24ece52c14437dd9d4b694022326b69c511f107ee0ad168bd5e7d366d8f10aa7"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8fbfded833cc733ce644d2dc55f509e3b05c178e75ebaab7418da75e3be8808"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57f6d9692374b908984c3b0dbca83447dfa3676259280f0326b9db5301bf7186"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fffd16fa3cfbc9816785aafa1aebcd78e3330f251a80bff14beac0fb9aab27ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc9e3c594f098a3f12914d8b0245ed4834fb528e61cea551c6d2acc9d8370eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33e25b456f415e0ad1e849e5395b2b82d62a8a110350cc7b081844014b3fb7b2"
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
