class Gptop < Formula
  desc "TUI GPU monitor with support for Apple Silicon and NVIDIA GPUs"
  homepage "https://github.com/evilsocket/gptop"
  url "https://github.com/evilsocket/gptop/archive/refs/tags/0.2.0.tar.gz"
  sha256 "87c63ed6b63627d7d6e3aca316d401e4dde5dd99bc8799f2e74a3d494a4a62c5"
  license "GPL-3.0-only"
  head "https://github.com/evilsocket/gptop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "358c92a5e9f93d680c0eea179470da4e12680d26db9b6948b3d64ced7cd5fe9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa15a887dc2dc27b40707280689f40c6cfbabb881900cdb8b18b0693dcbf3cfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d9de35b156f44f8727edcdfb5eb1861b221b06ea0a95762bf481c62569a31f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4befb730e2f406081edd97852c7a7f872fe0fc87ad907961779fda8c7d09e56c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ef388ed52db87fc8751bb9ea7c09bc659e3470c723347e844ae9bdb4eeb222f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gptop --version")

    if OS.mac? && Hardware::CPU.arm?
      output = shell_output("#{bin}/gptop --json 2>&1", 1)
      assert_match "Apple backend init failed", output
      assert_match "No supported GPU backend found", output
    elsif OS.mac?
      output = shell_output("#{bin}/gptop --json")
      assert_match "\"devices\":", output
      assert_match "\"gpu_metrics\":", output
    else
      output = shell_output("#{bin}/gptop --json 2>&1", 1)
      assert_match "No supported GPU backend found", output
    end
  end
end
