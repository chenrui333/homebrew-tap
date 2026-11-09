class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v5.0.11.tar.gz"
  sha256 "3ecc9aee3002c54dc3f70f9d9f5549b4ce3c2ee5f92482fecd2c32d984f856a9"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d851fd7445551c2d7a92fdc68b488e134894f3a6e8aa28d5d33be396e380bd98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d851fd7445551c2d7a92fdc68b488e134894f3a6e8aa28d5d33be396e380bd98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1be93abac70d2b8f49c75274354f7dedba6199ea45cb627f2adf06eef035846e"
    sha256 cellar: :any,                 x86_64_linux:  "610e8502bc08f6d7902033524998b4ee46400a7d512896d5568e449538821271"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  # vaults3 is an S3-compatible server; the test queries its loopback health endpoint.
  allow_network_access! :test

  def fetch
    cd "web" do
      system "npm", "ci"
    end
    system "go", "mod", "download"
  end

  def install
    cd "web" do
      system "npm", "run", "build"
    end
    (buildpath/"internal/dashboard/dist").mkpath
    cp_r "web/dist/.", "internal/dashboard/dist"

    ldflags = %W[
      -s -w
      -X main.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"vaults3"), "./cmd/vaults3"
    system "go", "build", *std_go_args(ldflags:, output: bin/"vaults3-cli"), "./cmd/vaults3-cli"
  end

  service do
    run [opt_bin/"vaults3"]
    keep_alive true
    working_dir var/"vaults3"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaults3 --version")

    port = free_port
    config = testpath/"config.yaml"
    config.write <<~YAML
      server:
        port: #{port}
      storage:
        data_dir: #{testpath}/data
        metadata_dir: #{testpath}/metadata
    YAML

    pid = spawn bin/"vaults3", "--config", config.to_s
    sleep 2
    assert_match '"status":"ok"', shell_output("curl -s http://127.0.0.1:#{port}/health || true")
  ensure
    Process.kill("TERM", pid) if pid
  end
end
