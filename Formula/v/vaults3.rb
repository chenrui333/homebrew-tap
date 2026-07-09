class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.10.tar.gz"
  sha256 "583803415c5c2eeb9904019b59811a33fd7efff5af9418e1fcbc7f266c2886ca"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ead8c7ab7b5ced8ec662bd085fd7dad4134f71a4dd59548f006cf8574e44e59f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ead8c7ab7b5ced8ec662bd085fd7dad4134f71a4dd59548f006cf8574e44e59f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ead8c7ab7b5ced8ec662bd085fd7dad4134f71a4dd59548f006cf8574e44e59f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f106f0804e508b872f0264f1a0d58a6dd5113d9cd149617aa449d0c984fca098"
    sha256 cellar: :any,                 x86_64_linux:  "d8b023d25f9af97f7bbb571dadf91b1d5d8506883447621f0c7bcf867e467654"
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
