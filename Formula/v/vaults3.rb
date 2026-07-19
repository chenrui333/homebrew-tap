class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.25.tar.gz"
  sha256 "96034675d25978c057841185f31b3df51d3f4579481375c2c556cb7460300da8"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa4b6c62503de568f16c4899e9373db3bbe6b2854d3a52810b95454e5c4a9fe0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa4b6c62503de568f16c4899e9373db3bbe6b2854d3a52810b95454e5c4a9fe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa4b6c62503de568f16c4899e9373db3bbe6b2854d3a52810b95454e5c4a9fe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6421659f0069a5751034d7ac87b6c36df950541905f9816e1df246d0c853d487"
    sha256 cellar: :any,                 x86_64_linux:  "76b23569ee65cce97e144b601ae032410d8654ca57c62e6aa8a0e56d13fc1094"
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
