class Psq < Formula
  desc "Lightweight postgres monitor for the terminal"
  homepage "https://github.com/benjaminsanborn/psq"
  url "https://github.com/benjaminsanborn/psq/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "13578590f221097086ac3a3b10816f8aa8ab4cd0ecc61b47ea40183e706c6890"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "565e4e0a8f3841c40622296136e6221d0e4ff7803568f4a6b591bfb6d4fec9ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "565e4e0a8f3841c40622296136e6221d0e4ff7803568f4a6b591bfb6d4fec9ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2abc5658ea068aa98d36fe15127c0bdb0fb7730dd303c521c84d7ee7dfdfed00"
    sha256 cellar: :any,                 x86_64_linux:  "476432b3541e255746c82bf17b1816d477b33d680fda9cad9f8dcc5628e188aa"
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
