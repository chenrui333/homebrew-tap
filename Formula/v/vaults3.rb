class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.2.15.tar.gz"
  sha256 "c8652729f0b9690e11ac52e854066fbf9e7988e81fbd8db357b881792d43ca08"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68d5666b9c65b4e27fa4489f0775eb72075ec9eb93984ac37e27791af856d593"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68d5666b9c65b4e27fa4489f0775eb72075ec9eb93984ac37e27791af856d593"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68d5666b9c65b4e27fa4489f0775eb72075ec9eb93984ac37e27791af856d593"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5ff8bd763216ec09bf3a44a3d3797b871a62c39b0d0cda402ba5cd7ab1ffc30"
    sha256 cellar: :any,                 x86_64_linux:  "a27c425bf6310826e93b60bd26f96677c237e25cce98b57c1a16da2ec1419ff2"
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
