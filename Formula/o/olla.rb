class Olla < Formula
  desc "Lightweight & fast AI inference proxy for self-hosted LLMs backends"
  homepage "https://thushan.github.io/olla/"
  url "https://github.com/thushan/olla/archive/refs/tags/v0.0.24.tar.gz"
  sha256 "8c17611250a74106f398c7b7df68ce63e31d94fad15538a511e034ed7b40193e"
  license "Apache-2.0"
  head "https://github.com/thushan/olla.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb2db52686cf80c97be79da0b88c112b4cec2c8d9580668565ab50886abab7eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb2db52686cf80c97be79da0b88c112b4cec2c8d9580668565ab50886abab7eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb2db52686cf80c97be79da0b88c112b4cec2c8d9580668565ab50886abab7eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc1ebb9289011470e87342ef5d3ea212ce182634da216ec61fa45dc115330b9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84eb385ff1f192f8518b17cc0c73213c9ed63bafbbdaf1bcd35b231acfb6258c"
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
