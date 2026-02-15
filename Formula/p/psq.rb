class Psq < Formula
  desc "Lightweight postgres monitor for the terminal"
  homepage "https://github.com/benjaminsanborn/psq"
  url "https://github.com/benjaminsanborn/psq/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "38537e0a4cd30b01dcc2ce144829ecab9ff8714e26339f312354f6122eafe6be"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7027b9e667425f498a8b00079d57a379ce5ab07b0b498d182bdb4c6ae3f0e998"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7027b9e667425f498a8b00079d57a379ce5ab07b0b498d182bdb4c6ae3f0e998"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7027b9e667425f498a8b00079d57a379ce5ab07b0b498d182bdb4c6ae3f0e998"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50bbda47d047d6dcbc3e01cc7690f514e523cdf6390653d770643d07d3c84aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "987b0c98a61dcb36eebdcb2c20415597f9d115818effa94a496e4ae78db53b6c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Fails in Linux CI with `/dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"psq", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Initializing", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
