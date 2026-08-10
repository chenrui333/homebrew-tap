class Olla < Formula
  desc "Lightweight & fast AI inference proxy for self-hosted LLMs backends"
  homepage "https://thushan.github.io/olla/"
  url "https://github.com/thushan/olla/archive/refs/tags/v0.0.29.tar.gz"
  sha256 "9ae9d83bcb631f592fa987a14468b1a43cefb662f8259da750044d932a14a2d7"
  license "Apache-2.0"
  head "https://github.com/thushan/olla.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12ae2769323071d772cefc99bb1a61e69d62f8c78ff6106d5ab6d9e18ca902ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12ae2769323071d772cefc99bb1a61e69d62f8c78ff6106d5ab6d9e18ca902ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12ae2769323071d772cefc99bb1a61e69d62f8c78ff6106d5ab6d9e18ca902ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1738acf92f66e9ce922dc92a04e6ad544ad2b91c019e4f4cb5b118c2c133d938"
    sha256 cellar: :any,                 x86_64_linux:  "31e7eaa0aa17cf47fd1df3703dbff4ecf5fbb20ef642f83ecb2f6e78f1d240df"
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
