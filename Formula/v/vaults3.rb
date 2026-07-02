class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "7f7154956eaab3e0ea4a10bb19872406a1a400f0ff65977c908ecbff0c1b0435"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "566d1b4ce2f415386280e1af1acd4ae476190bd28d9ecfe832e116443315481e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "566d1b4ce2f415386280e1af1acd4ae476190bd28d9ecfe832e116443315481e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "566d1b4ce2f415386280e1af1acd4ae476190bd28d9ecfe832e116443315481e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b199bb4f9bdd2973483675a7fe8ba900e3be514e5206a6dc023a7d7dfc462c13"
    sha256 cellar: :any,                 x86_64_linux:  "1a8d3ae86d87e4684c1e9b173e1ea971dfd00bd862269651e6edf3d1e9b5460c"
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
