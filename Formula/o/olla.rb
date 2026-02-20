class Olla < Formula
  desc "Lightweight & fast AI inference proxy for self-hosted LLMs backends"
  homepage "https://thushan.github.io/olla/"
  url "https://github.com/thushan/olla/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "20df8301baeb7736054b94971ddddf93e1308b6f9b9b33e695d0613b848e6223"
  license "Apache-2.0"
  head "https://github.com/thushan/olla.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1c7bbce00972ad60ca3ec54bb5eb0484dee6d68c28dc464fee0d1a528cb1861"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1c7bbce00972ad60ca3ec54bb5eb0484dee6d68c28dc464fee0d1a528cb1861"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1c7bbce00972ad60ca3ec54bb5eb0484dee6d68c28dc464fee0d1a528cb1861"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08f8b059c3a70e6a6ac740865e3e12e3041bf0083ce2427a06d09f747872b859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ec76e1a4b8ae23c8f0912b3de84ba821cc2ebcf1a4da0e954cc0511e6b29c43"
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
