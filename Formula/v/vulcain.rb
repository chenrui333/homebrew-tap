class Vulcain < Formula
  desc "Fast and idiomatic client-driven REST APIs"
  homepage "https://vulcain.rocks/"
  url "https://github.com/dunglas/vulcain/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "fa93f5d9352528ab708ffa5ec472841715622775ed66566e6a4acffe37bda3a1"
  license "AGPL-3.0-only"
  head "https://github.com/dunglas/vulcain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7eca5631175861c2136c426c3e40335f38d9f8641a6b67e2970d0c31f445cc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4db62ad76e403d8ed43ef301eca22b7fb8d36093e370f0356951499525c6fb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50605e16323afd50ba0daeed70202203e932a6cd7fff533408140308d6f964ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "170be72ad2b31f4f83ea9e2c7293e782b0d18898f3037b2598873af1acd6b9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ffac89b50af55a2f7269f5be22b303eef096aeea9f73f5a09fe358a6eae4a07"
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
