class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "3a1934043642dc2751e802dc66ecdc435d649a9eea22a0b674eaf43d14968849"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e874b7ceb870c0a735d6a392aa56127cec316e7c0eb66ab757ff57b9e1fe334"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51debe5b2bcaf20ef067b3ce942138980bf109ed259f2bff56107f9d1cd890bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac90da0bd9807c3d07f32f7766c45a03fc1dc5c12dac1969c19ba2301dd20788"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfe69dba3ed80bf2ef4204ddfed702cc4bc6a697c1ce80d78c65aea655a1abea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6d70a0e0e514206a0b3cee02ac5bf1f86d774890e9a590d8984d14133d15cf3"
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
