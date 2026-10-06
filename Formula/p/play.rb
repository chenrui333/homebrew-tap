class Play < Formula
  desc "TUI playground for grep, sed, awk, jq, and yq"
  homepage "https://github.com/paololazzari/play"
  url "https://github.com/paololazzari/play/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "7abe1745099e9b4d66e5fc62a1180f2170e8351953d0c6978dfc4719591cd00e"
  license "Apache-2.0"
  head "https://github.com/paololazzari/play.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0350514e0ece56010a42611db2e804beb4e3aff2658ac6133a30873af44748da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0350514e0ece56010a42611db2e804beb4e3aff2658ac6133a30873af44748da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e30f75a9c4206212a7a5a39e5e04310883aa6d9dec96cfa6ae551940acc3a56b"
    sha256 cellar: :any,                 x86_64_linux:  "e6915e21bd0a902764285039cbc70d90c6ffe9bdd67931f9078d01c7415d2d54"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/play version")

    output_log = testpath/"play.log"
    with_env TERM: "xterm-256color" do
      pid = if OS.mac?
        spawn "script", "-q", File::NULL, bin/"play", "grep", [:out, :err] => output_log.to_s
      else
        spawn "script", "-q", "-c", "#{bin}/play grep", File::NULL, [:out, :err] => output_log.to_s
      end
      sleep 2
      assert Process.kill(0, pid)
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
    output = output_log.read
    assert_match "\e[?1049h", output
    refute_match "grep not found", output
    refute_match "No such device or address", output
  rescue Errno::ESRCH
    flunk "play exited before it could be terminated"
  end
end
