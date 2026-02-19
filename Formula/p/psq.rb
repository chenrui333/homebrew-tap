class Psq < Formula
  desc "Lightweight postgres monitor for the terminal"
  homepage "https://github.com/benjaminsanborn/psq"
  url "https://github.com/benjaminsanborn/psq/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "cc1b41192a21d16352d93c012682176723da0551080f1bd5e3d77b8b7aed3da1"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46011d865b2edfc9c5a1b5b03d4f63dceb6c3738ce7c4f9e270185d82a14e5e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46011d865b2edfc9c5a1b5b03d4f63dceb6c3738ce7c4f9e270185d82a14e5e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46011d865b2edfc9c5a1b5b03d4f63dceb6c3738ce7c4f9e270185d82a14e5e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a60ce53ba0899d8f896f7bfdbea37dba6920e5674527bf528edbc58c79cb395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62c2e7aa45cc03fe7e39ab40fc6e0f26212e3cdd711280646f1ec0756255662e"
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
