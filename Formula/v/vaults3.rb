class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.2.11.tar.gz"
  sha256 "9a26e08a06c42081149f5b7733750bf26f5708987aa24f7f71f94ecb1040f86f"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "300c30f2193fd12836e2754913c184531b36415befe0f269dbe382353618c562"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "300c30f2193fd12836e2754913c184531b36415befe0f269dbe382353618c562"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "300c30f2193fd12836e2754913c184531b36415befe0f269dbe382353618c562"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea5fcd1bf95f27a5f6399c84c5839a1ee8564083bd54ad9d84e48fb124b27d30"
    sha256 cellar: :any,                 x86_64_linux:  "bc802e5416148037e975cbdad083425096152b5dbd64937e6469abbd18debc97"
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
