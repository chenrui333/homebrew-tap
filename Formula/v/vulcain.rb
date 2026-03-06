class Vulcain < Formula
  desc "Fast and idiomatic client-driven REST APIs"
  homepage "https://vulcain.rocks/"
  url "https://github.com/dunglas/vulcain/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "d3d4cf10bcc43f9f8aaca5940f61d7aa3d6952cf8f2d55112fbbca4adb2a9773"
  license "AGPL-3.0-only"
  head "https://github.com/dunglas/vulcain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3e83d9cc7902fff2aa0379516717d5813240ff069ecc2996756643f813a9810"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a48b746fd17a8c0154d6b9a46df50c471456676831fb0b1ed2ba140b4854f60a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3cb2cfd2fe3ea2ed6485f01717befbce8a9e287269bf33ba6ac0b5efb036476"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5ba98f22da2a77f54ca38705f301b396eb340ec78cd7d30987cdb1eeab53498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0102ab3b01447490c96506a4bbd86c7f1b27271b5b0e8c5fa5214eb700c79f2a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/caddyserver/caddy/v2.CustomVersion=Vulcain.rocks.#{version}"

    cd "caddy" do
      system "go", "build", *std_go_args(ldflags:, tags: "nobadger,nomysql,nopgx"), "./vulcain"
    end
  end

  test do
    port = free_port

    assert_match version.to_s, shell_output("#{bin}/vulcain version")

    (testpath/"Caddyfile").write <<~EOS
      http://127.0.0.1:#{port} {
        respond "Vulcain API"
      }
    EOS

    pid = spawn bin/"vulcain", "run", "--config", testpath/"Caddyfile"

    sleep 2

    assert_match "Vulcain API", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
