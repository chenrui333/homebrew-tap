class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.61.tar.gz"
  sha256 "9c3203e8d370fd3a67c8d5c00d39363d8b9fe8eaf5cd34011f886904a10c7ee9"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2935f52e96ab220c3d29ae1e0f86db2caa2864e39380cd04b8913a059dc5aa45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2935f52e96ab220c3d29ae1e0f86db2caa2864e39380cd04b8913a059dc5aa45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2935f52e96ab220c3d29ae1e0f86db2caa2864e39380cd04b8913a059dc5aa45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae51083965a73394fc2ba8fdd5d39f4adb8bf829ee08b2f3efcd3b314fd777ec"
    sha256 cellar: :any,                 x86_64_linux:  "f3fbbf9d45e0414397fbc86b5b09257cbccabb6a87d5f2e9534655dde4605a44"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "web" do
      system "npm", "ci"
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
