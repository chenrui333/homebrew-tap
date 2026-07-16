class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.19.tar.gz"
  sha256 "fc46aa5def72c0bb2a101adf106ea76716e3dc80049bb9dee664fe1b4bc55903"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36bad349d307c4accf62fef7baa8fe16c5aa40f977c4d41e396782c0d944cb81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36bad349d307c4accf62fef7baa8fe16c5aa40f977c4d41e396782c0d944cb81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36bad349d307c4accf62fef7baa8fe16c5aa40f977c4d41e396782c0d944cb81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69db1c10e21c49dab2e07eaa5e970a9f67a5348f78cd4de06f095e6ced67a0ad"
    sha256 cellar: :any,                 x86_64_linux:  "5a6c697c1fa993b88e7bd7e19508496735a6d74506aa507468c74a53c319f713"
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
