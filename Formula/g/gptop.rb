class Gptop < Formula
  desc "TUI GPU monitor with support for Apple Silicon and NVIDIA GPUs"
  homepage "https://github.com/evilsocket/gptop"
  url "https://github.com/evilsocket/gptop/archive/refs/tags/0.2.0.tar.gz"
  sha256 "87c63ed6b63627d7d6e3aca316d401e4dde5dd99bc8799f2e74a3d494a4a62c5"
  license "GPL-3.0-only"
  head "https://github.com/evilsocket/gptop.git", branch: "main"

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
