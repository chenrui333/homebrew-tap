class Olla < Formula
  desc "Lightweight & fast AI inference proxy for self-hosted LLMs backends"
  homepage "https://thushan.github.io/olla/"
  url "https://github.com/thushan/olla/archive/refs/tags/v0.0.22.tar.gz"
  sha256 "4de03299f54bbb809274331c33f841b3636d8eab277c5edfc40511ffb2cb20db"
  license "Apache-2.0"
  head "https://github.com/thushan/olla.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe53b5a4f4a60ca425bc02a735e609523bced97fa00c24cf4d2b449aa4b30c60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe53b5a4f4a60ca425bc02a735e609523bced97fa00c24cf4d2b449aa4b30c60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe53b5a4f4a60ca425bc02a735e609523bced97fa00c24cf4d2b449aa4b30c60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7c4eaaa7e387b8bc07908036cf771fb4aa7736600d905b40a8888f5c38dda0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef0a6aff1b57f5a0de6b3eb4622c58ecb9b21290489de1c5abcb38b32eb2b428"
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
