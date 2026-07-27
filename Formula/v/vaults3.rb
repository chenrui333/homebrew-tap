class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.38.tar.gz"
  sha256 "d335db7135124ce1c803fcf62d45d19d4a7e8ed477e4575b56086a73f296a3ea"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87d0e8f3efe4bd420cfc258a2355586a9d09da73af6857d49151350f539014be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87d0e8f3efe4bd420cfc258a2355586a9d09da73af6857d49151350f539014be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87d0e8f3efe4bd420cfc258a2355586a9d09da73af6857d49151350f539014be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a70fa6172eaffd65dadeec88cd3ff6f34b2af6eafe98a3601a5043feb6efd2b0"
    sha256 cellar: :any,                 x86_64_linux:  "5885a1057fe64aae56f19779618bf734511d11f904f466e11b9af198d9e2813a"
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
