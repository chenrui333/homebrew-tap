class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.77.tar.gz"
  sha256 "70f7a97d2bc853df4491602287d0c11e4c48dd62da80e5d65bea77d74303a335"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3eb7100dd78647d8ef652b5ee7cb877e742035ce43b77d99fc18325fa144bd8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eb7100dd78647d8ef652b5ee7cb877e742035ce43b77d99fc18325fa144bd8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c49fce87bd58b5994976d94b75a1e75d3deb03eaf9f126911b6df2c330e80e5"
    sha256 cellar: :any,                 x86_64_linux:  "caafb44809f16f261bc51aaf05ac1a380e7577f72ac7da07b66723f67047ffa8"
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
