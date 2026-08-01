class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.46.tar.gz"
  sha256 "57f2e92758fd6eefb87cddcee9b20089b7ef34c54e35d49d1cb69d8241b1bfcc"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f7dedc0c04a955677e9324ba59918b891c4d391345c8c7948cabad25bd10f36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f7dedc0c04a955677e9324ba59918b891c4d391345c8c7948cabad25bd10f36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f7dedc0c04a955677e9324ba59918b891c4d391345c8c7948cabad25bd10f36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dd3ddb43c5935ccaafb90315219dcb26c2f14a2b821dcf3cad74fdcb7be2d50"
    sha256 cellar: :any,                 x86_64_linux:  "e0c70331a0d3bff997c02e2e2df1f0e4b6cbf8a1dd5e6694e00509226afde3d6"
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
