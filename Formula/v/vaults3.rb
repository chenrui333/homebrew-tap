class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "959215883ef3675ab90ee7d5d76860f3b6aba939f2de931f4589c94d3bde6268"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d334a3a32391c921e74e1441895607417e73935029fb587f39d77bed5323be6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d334a3a32391c921e74e1441895607417e73935029fb587f39d77bed5323be6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d334a3a32391c921e74e1441895607417e73935029fb587f39d77bed5323be6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4c2f46db5c2e45098d6ebcf955163d7c32de6767630504b0f089df9482d111a"
    sha256 cellar: :any,                 x86_64_linux:  "c79cb4ac9578fa1f869aed5c66e824dc6883a73c2a5b5b96183303547fe7cb7c"
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
