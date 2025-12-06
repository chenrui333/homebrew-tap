class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "d696d7336eb7bcccc12b4599cc0e4917d71b0a318cd467f7c8c0e7fa93c11490"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b466c33e81f9846724d4f66282585399dc9b1ba675d35530d148959e4d127d72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5eb70eea2e77dc04f4d7c106ff54cda5dd5644c57f2003401e0f08b12dbf210"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "995564c1ae0686054c144ff6dfa1d0210069b0b1d0b028a4927b4408e4ae6445"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8b2711fe5f64d01667056300e046d7868856b7c22c5c99b6c6125a2ca01dca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0994e9957f57c0671969012880de373141f1733e19b6ec1f296e5f630013ad05"
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
