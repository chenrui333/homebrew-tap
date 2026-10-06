class Rip < Formula
  desc "Fuzzy find and kill processes from the terminal"
  homepage "https://github.com/cesarferreira/rip"
  url "https://github.com/cesarferreira/rip/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "c0e57126bb07a11352bccf30e067b35cb9a3928d458789f77157ca2ae038603b"
  license "MIT"
  head "https://github.com/cesarferreira/rip.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26f2d2bc1153cf4bb1292f8bf21129e18801a754c921e18e51b3af0bb4d70f77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71958295cab1322edee748c5c3e29bb9bf5bacfc7bd260fa0a512ec8946907f6"
    sha256 cellar: :any,                 arm64_linux:   "de6cba9d06b8b48f8efc608592b85caff9785d492008a4cd21a7393c9fb045c9"
    sha256 cellar: :any,                 x86_64_linux:  "a824aad79fb25271040740098ce5c06be2ca2b527259540fb0b0cf31f7e2735f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rip --version")

    # Kill a uniquely named local process by name filter instead of a TCP listener.
    target = testpath/"riptarget"
    cp "/bin/sleep", target
    pid = spawn target.to_s, "60"
    sleep 2

    output = shell_output("#{bin}/rip --filter riptarget --confirm-nuke")
    assert_match "Killed", output

    Process.wait(pid)
    assert_predicate $CHILD_STATUS, :signaled?
  end
end
