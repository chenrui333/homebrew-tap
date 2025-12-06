class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "d696d7336eb7bcccc12b4599cc0e4917d71b0a318cd467f7c8c0e7fa93c11490"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2773e12c9f97dc498bf2e8033471616a9c7fabd2031d17a505d5d16d3fc4b2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6127272d01c318c2e4188a421143644529b52f06d4691bb37ae7d700f16cfe1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7c0789268a5bef82d89be647384a695b08d4bb8e9637c795280bdcfae32d4dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdd3cdbbfb72e91a8e96fd90270a6bd62abbc3450d4a8fc956954ba5ca7dd1df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a32bd7119f49cc9177470aeecfa4b523830f37306b46c0ae11ef068093ed524"
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
