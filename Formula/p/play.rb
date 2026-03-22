class Play < Formula
  desc "TUI playground for grep, sed, awk, jq, and yq"
  homepage "https://github.com/paololazzari/play"
  url "https://github.com/paololazzari/play/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "7abe1745099e9b4d66e5fc62a1180f2170e8351953d0c6978dfc4719591cd00e"
  license "Apache-2.0"
  head "https://github.com/paololazzari/play.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfaefe5c82199bf64d4a6a969e6ab8af565f8a4d531d911b48d57601e43b3195"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfaefe5c82199bf64d4a6a969e6ab8af565f8a4d531d911b48d57601e43b3195"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfaefe5c82199bf64d4a6a969e6ab8af565f8a4d531d911b48d57601e43b3195"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81c940526e253fbbdce3a1d6900aedc38978e16e9ebbbf1ba3882a1dafa7b9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cf6d67230e72d706780c806ae63f640b34b6f1c7b7b2e51b4150aa17bbb3bd4"
  end

  depends_on "go" => :build

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
