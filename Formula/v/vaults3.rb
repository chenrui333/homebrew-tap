class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.57.tar.gz"
  sha256 "ff019d4905dbf0a0f2b0a61ec46d282576681632143b4679e0c717b7bb84330b"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9edccf7e7e67825834423ee6ef1e3e9055dc845dc2ad86fbdf9c7e2248deda5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9edccf7e7e67825834423ee6ef1e3e9055dc845dc2ad86fbdf9c7e2248deda5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9edccf7e7e67825834423ee6ef1e3e9055dc845dc2ad86fbdf9c7e2248deda5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f9f307df6d0e2de9a483f3414ab99d4e6eacb449ba1cee5e44b6e63692bf17c"
    sha256 cellar: :any,                 x86_64_linux:  "e8e5f62854310be20ce2ee61a3522fb00621e53d78e1c21c9f4f0de65c1ea562"
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
