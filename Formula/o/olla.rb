class Olla < Formula
  desc "Lightweight & fast AI inference proxy for self-hosted LLMs backends"
  homepage "https://thushan.github.io/olla/"
  url "https://github.com/thushan/olla/archive/refs/tags/v0.0.20.tar.gz"
  sha256 "e9de07603b03d291c42cb3ee4d33a8a9b2e77b633817396b71e77b19f8730604"
  license "Apache-2.0"
  head "https://github.com/thushan/olla.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ab6a739f92a80dfdd525d783108c22c024b3676a477d73c1b2245bf435fe5dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ab6a739f92a80dfdd525d783108c22c024b3676a477d73c1b2245bf435fe5dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ab6a739f92a80dfdd525d783108c22c024b3676a477d73c1b2245bf435fe5dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1716139e081648e0eb069301070a74bdad89c7d23e50729ee458016570f1f846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1f746a6abb583d268dbe1addc7c372345a22cf3dcda099bfb5308182754a214"
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
