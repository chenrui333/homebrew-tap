class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.52.tar.gz"
  sha256 "46abf8dfebb2b1af4c46405990625020b6987629d26a6f5830798f65fdeb4d32"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "818c8039aa69ddeaa4a24ba3cd575a1524d2e5c3abad9da2b6d18dcb698e6c85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "818c8039aa69ddeaa4a24ba3cd575a1524d2e5c3abad9da2b6d18dcb698e6c85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "818c8039aa69ddeaa4a24ba3cd575a1524d2e5c3abad9da2b6d18dcb698e6c85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17724a50a515ab2e18642ce61c1344d8a4567da08ec7ffb83e2d50e97a0d3b42"
    sha256 cellar: :any,                 x86_64_linux:  "c6a09c137dcd11280be6b216cd40fd81472cb9861f26411dc654ab7ce47d0dee"
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
