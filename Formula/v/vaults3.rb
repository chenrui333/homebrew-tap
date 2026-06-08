class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "d1de222e92f709500d396e3c4cfbedb84c4ac0483bb7a67252e1bf7f0244ad3e"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7c6a7df9f19e707ab8ad477c4ef522a421177615061bfa0017f7ca6227dcdac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7c6a7df9f19e707ab8ad477c4ef522a421177615061bfa0017f7ca6227dcdac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7c6a7df9f19e707ab8ad477c4ef522a421177615061bfa0017f7ca6227dcdac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c5254a302e5abfa531006a433fa4af4958f598220bc32c855c3dba8a3afc217"
    sha256 cellar: :any,                 x86_64_linux:  "702e4930a38b9fed33ab6167925fc11a8209346f067ff0fedec242102ddb5417"
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
