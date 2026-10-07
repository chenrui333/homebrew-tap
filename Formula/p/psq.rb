class Psq < Formula
  desc "Lightweight postgres monitor for the terminal"
  homepage "https://github.com/benjaminsanborn/psq"
  url "https://github.com/benjaminsanborn/psq/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "cfee078ce51b3e9d7907994d137568a421ba926a071be5224e198d1fab5271e7"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11ac4796281754d192a35f75b2d27ed3f0a4ffd189b810ae5035a22708ef138a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11ac4796281754d192a35f75b2d27ed3f0a4ffd189b810ae5035a22708ef138a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f4e80ce1129772cb90cc1a722bb66bf889f9832a6a181c30037711bd6beafa0"
    sha256 cellar: :any,                 x86_64_linux:  "e075c5c91c1b65b6fe084e8ad863c054b2c9fa14b493f3550d8915c90a96b7e4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
