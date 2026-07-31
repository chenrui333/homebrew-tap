class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.43.tar.gz"
  sha256 "93b7739d62b59cc5ec442ac63a09a708f0a50f32f3d8255e9214fb04e63990ef"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dae9c041e687756343828980157b4deb1c296122152aa2822c9c84004a0bf3bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dae9c041e687756343828980157b4deb1c296122152aa2822c9c84004a0bf3bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dae9c041e687756343828980157b4deb1c296122152aa2822c9c84004a0bf3bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbd70544f83b048ae97ab73a547d2bc6ad7b46a269321a29df6cf7f926ccf4a9"
    sha256 cellar: :any,                 x86_64_linux:  "04015301953257a54deeaae5b404287d9a6862e505b07c52cea97f1ee1d45b63"
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
