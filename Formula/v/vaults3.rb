class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.42.tar.gz"
  sha256 "4cc12fc196baff46015462dce08d8cd8d5d3a82e4b511650684ab586b5c23734"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e11d12c355b426b381158bdd1538695d0a29a904fcb796f91ba376b34fbd8631"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e11d12c355b426b381158bdd1538695d0a29a904fcb796f91ba376b34fbd8631"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e11d12c355b426b381158bdd1538695d0a29a904fcb796f91ba376b34fbd8631"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13d57efc3b67c93c29898970b717373f65d7ef805c02ae29b5b0545a3c8e9a1c"
    sha256 cellar: :any,                 x86_64_linux:  "3ddc995ea343382ec7b235a6e2088b85cf2ca9969c086b6355a16c70bceb8b93"
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
