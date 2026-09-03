class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.67.tar.gz"
  sha256 "65b724b788ca5015f033711ca10266c0e8f8264f4d9cfdd8a7d8101c64f19f77"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18d2d663c8c148ef185419abd2d69a91ce14bc66ca22573a2c110cffc3354d2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18d2d663c8c148ef185419abd2d69a91ce14bc66ca22573a2c110cffc3354d2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18d2d663c8c148ef185419abd2d69a91ce14bc66ca22573a2c110cffc3354d2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "855c611e1e3336765b38d380c8cf9653d84546900da840e19a0ac3dd80ac77fb"
    sha256 cellar: :any,                 x86_64_linux:  "1d604baa4949977753bf5336be7cc46038915c1c02f025a65fe8b0bcdd21518f"
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
