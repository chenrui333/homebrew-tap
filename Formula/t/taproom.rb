class Taproom < Formula
  desc "TUI for Homebrew"
  homepage "https://github.com/hzqtc/taproom"
  url "https://github.com/hzqtc/taproom/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "e4fc7e960fbb9bdca6f255f19e5edf8aa8be78925a8e36ab7b1344a7bb3dd505"
  license "MIT"
  head "https://github.com/hzqtc/taproom.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c38aa6ffc6ba43898fe6d569496907e1abeb8c4da358417e407535ec60ebc62b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c38aa6ffc6ba43898fe6d569496907e1abeb8c4da358417e407535ec60ebc62b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c38aa6ffc6ba43898fe6d569496907e1abeb8c4da358417e407535ec60ebc62b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46a6b4b482b2cf12d129682c9db72959efd54a737c8cbbd6dd085d42f88ae8ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c43d4bb2b7ae0ac712c873505ad3e73efdd2841bb3b58d8c16e17eae32737922"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taproom --version")

    # Skip test on Linux GitHub Actions runners due to TTY issues
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"taproom", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "[1/6] Loading all Formulae...\r\n[2/6] Loading all Casks...", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
