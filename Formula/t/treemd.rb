class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "d66a947ea705ded52bbc69859e84d4ccc9f8d62e698dd90be4b8a206c0c6995f"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ea46b5e2c3086cb55b31d219de4cfe3aa4e93874108518f9ca26957d2e33c3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cbf0f9980356d9dfffe011402eae7af046490dc3226dce248e5154696d49c33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "088133e147aeea7073a0494ddc208ea28c2facc91d7ef1464064f7cda4ee1349"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44f5536dad69a126f0f82b73af6ce79a64b82970f487dca1714ad0f11bb0b980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf0d52634d192782e71532d64b239b9440a680c228811105963da02ce5ecb85d"
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
