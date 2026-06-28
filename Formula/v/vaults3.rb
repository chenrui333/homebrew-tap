class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.2.10.tar.gz"
  sha256 "4986b9e8019b77868b1afdcf8e7c29e544f147eee8301ae59f9d855f1626c3aa"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba6c06c9586bd9f8a3e9d5e302b271e8a84cf276cbc2c0c96594f47433f48b50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba6c06c9586bd9f8a3e9d5e302b271e8a84cf276cbc2c0c96594f47433f48b50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba6c06c9586bd9f8a3e9d5e302b271e8a84cf276cbc2c0c96594f47433f48b50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86175dc4512f5ef9145426122ef0b0006327217e5615e8d0d333d46f813c32b1"
    sha256 cellar: :any,                 x86_64_linux:  "7948c350ed237f29476a916913347f17eb0c5d8cbf0c8dcd6ff80c102fe09b85"
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
