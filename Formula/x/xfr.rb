class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.21.tar.gz"
  sha256 "4728498ad3b99633b83bac4bc890b8ae2b7ee7361c8d84e2c4a4eb371c833374"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebcd6968a87a913be20cc87ede1c31ea431f5e04e45887731f84989eac744fa3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7ebbe27fd60f22355d728196f49082314601b69443e4a7d21bc6ddc76e860a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f263dc97999c0563c445416dc592353b6427cbb6f56fc7ec20de27927ef035e8"
    sha256 cellar: :any,                 arm64_linux:   "18f1663f0c7328ef00c027acb948c6fd4f9215e33d071432e83e075cad78887b"
    sha256 cellar: :any,                 x86_64_linux:  "8a2432a6f13172349eeed147c47f45fb066b04bdbca64ddcffa492826e1a46a2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"xfr", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xfr --version")

    port = free_port
    server_log = testpath/"server.log"
    pid = spawn bin/"xfr", "serve", "--port", port.to_s, "--ipv4", [:out, :err] => server_log.to_s

    50.times do
      break if server_log.exist? && server_log.read.include?("TCP listening")

      sleep 0.1
    end
    assert_match "TCP listening", server_log.read

    output = shell_output("#{bin}/xfr --no-tui --json --quiet --time 1s --bitrate 1M " \
                          "--port #{port} --ipv4 127.0.0.1")
    assert_match '"duration_ms":', output
    assert_match '"throughput_mbps":', output
  ensure
    if pid
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
