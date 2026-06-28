class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.2.7.tar.gz"
  sha256 "6350f1b676832aa5a4f5dfe4f19dbe28cca064da0efac14ffc46d2c05e77b63f"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "badca02d587ba053604e0c15466afe67abb008b9075fa398ec16bd87c2b228ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "badca02d587ba053604e0c15466afe67abb008b9075fa398ec16bd87c2b228ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "badca02d587ba053604e0c15466afe67abb008b9075fa398ec16bd87c2b228ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d4115621e4a606ef18de93cfb9cd3b4cf57da94ba11a99d8c270f90160418ba"
    sha256 cellar: :any,                 x86_64_linux:  "0a091e69ca453331589eccbd35f90f1a71650058ecd8b24bfa630a8160458273"
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
