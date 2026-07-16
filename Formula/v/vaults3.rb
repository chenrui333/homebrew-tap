class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.19.tar.gz"
  sha256 "fc46aa5def72c0bb2a101adf106ea76716e3dc80049bb9dee664fe1b4bc55903"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "648c1244349c3c3a3f7b1f02bb03257e5375484d081f0de2b7d9f7d5e1f5c526"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "648c1244349c3c3a3f7b1f02bb03257e5375484d081f0de2b7d9f7d5e1f5c526"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "648c1244349c3c3a3f7b1f02bb03257e5375484d081f0de2b7d9f7d5e1f5c526"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d317038173be7aed28c9c4581cc0a8e7e78dc3c7bd2b2b4a2e8d2b4430f79c0"
    sha256 cellar: :any,                 x86_64_linux:  "17d08758635ef3a78bba6ac5cc7187cd3e387619928125c58e5273dcc23342c1"
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
