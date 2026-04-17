class Olla < Formula
  desc "Lightweight & fast AI inference proxy for self-hosted LLMs backends"
  homepage "https://thushan.github.io/olla/"
  url "https://github.com/thushan/olla/archive/refs/tags/v0.0.25.tar.gz"
  sha256 "9a4b318a22246d6e76568f3c8138950252cb825fabfcdb05b56c19ffa644dd35"
  license "Apache-2.0"
  head "https://github.com/thushan/olla.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b950c3c0c3d330e0ea1ff5c23716525d0a6d3668985959c1549eb8f62c0fbb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b950c3c0c3d330e0ea1ff5c23716525d0a6d3668985959c1549eb8f62c0fbb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b950c3c0c3d330e0ea1ff5c23716525d0a6d3668985959c1549eb8f62c0fbb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2bcee9ecf74d25be2bad76edd0f821d90a86440b2196ecb44d928f5851b9b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16d1b6a1752da55e2eb202b9c4d7eb44650a49e66f4c9bd772081f801f6fece5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/thushan/olla/internal/version.Version=v#{version}
      -X github.com/thushan/olla/internal/version.Commit=#{tap.user}
      -X github.com/thushan/olla/internal/version.Date=#{time.iso8601}
      -X github.com/thushan/olla/internal/version.User=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"olla", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/olla.log"
    error_log_path var/"log/olla.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/olla --version 2>&1")

    port = free_port
    (testpath/"config.yaml").write <<~YAML
      server:
        host: "127.0.0.1"
        port: #{port}
    YAML

    pid = spawn bin/"olla", "serve", "-c", testpath/"config.yaml"

    sleep 1
    begin
      assert_match "healthy", shell_output("curl -s localhost:#{port}/internal/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
