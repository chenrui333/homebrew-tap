class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.36.tar.gz"
  sha256 "19316c880eb2029338982a40dca91c5b858796527f8c0f5e84f1c9909020dee9"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a3b514bb9acc2f70e5f2ae8d5c9a9cdc1903245ba71b452d439280f619c5563"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a3b514bb9acc2f70e5f2ae8d5c9a9cdc1903245ba71b452d439280f619c5563"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a3b514bb9acc2f70e5f2ae8d5c9a9cdc1903245ba71b452d439280f619c5563"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb12a2f63e1d2b5d9d7f8877817f6092fbfc596c31c6de11cf6298de2a0c7808"
    sha256 cellar: :any,                 x86_64_linux:  "8e5bbf306a9db45c767888ba859df63a4fa7ebb463bd4ca88f2fc0a62034da98"
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
