class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.50.tar.gz"
  sha256 "52e4b4d4343b1e8a313dee06900812fed06aed837a56c34207ac713861d672f3"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "348967564c85c27bac9786bb216267874cbc132a6804c4a100594fd36f12a8f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "348967564c85c27bac9786bb216267874cbc132a6804c4a100594fd36f12a8f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "348967564c85c27bac9786bb216267874cbc132a6804c4a100594fd36f12a8f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e04d261792899148009559e1429770d0986ff771a2106194799b1f3ddcba40b9"
    sha256 cellar: :any,                 x86_64_linux:  "152f5d7baaed41658de6f7d67499eafd53341bd2de4de74de06f8459b6810ef9"
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
