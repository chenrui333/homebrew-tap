class Psq < Formula
  desc "Lightweight postgres monitor for the terminal"
  homepage "https://github.com/benjaminsanborn/psq"
  url "https://github.com/benjaminsanborn/psq/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "817f1a0f862cbe922d03f233b9df1e31c951daec679df1353033650b693c0b48"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0247a4900999cdc49d1f8042898a8d4dfd75c474b6471769c1bbae1bf3436612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0247a4900999cdc49d1f8042898a8d4dfd75c474b6471769c1bbae1bf3436612"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d80d9061f9db4394d616b9caee63c78e8e0e73a6d89752a8d36ac4a8a1d0b60c"
    sha256 cellar: :any,                 x86_64_linux:  "2f649c5cc496cd20450d3371115efefbff8483e92957a9f554dd78840b0922b1"
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
