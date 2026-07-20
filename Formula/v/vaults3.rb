class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.32.tar.gz"
  sha256 "7aad512a0006446d386169023e8e0b15e6a9f29eb6b5df126d5f70acdaf6328e"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f707068140b7956a5c1ecc8164a8a8cf50c14a655aef9ab06cfecf1e5b5a8e37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f707068140b7956a5c1ecc8164a8a8cf50c14a655aef9ab06cfecf1e5b5a8e37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f707068140b7956a5c1ecc8164a8a8cf50c14a655aef9ab06cfecf1e5b5a8e37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9fc5ed3d7f5c7206f661978b0261e156b12f877c5eae57c1195a2510e750857"
    sha256 cellar: :any,                 x86_64_linux:  "607d23e6c0957594d98d7a333d078b9c1de4814870e3b56bfa4696bf12d6214d"
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
