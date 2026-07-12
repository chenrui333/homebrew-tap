class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.16.tar.gz"
  sha256 "62e3e5ac60e08f408c952d3530b631c32617dd0765ff839faeda513e36cf975b"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55d39f144aebbec2efa99c7c7b65062e15017818c748fd872793a160255cd8e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55d39f144aebbec2efa99c7c7b65062e15017818c748fd872793a160255cd8e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55d39f144aebbec2efa99c7c7b65062e15017818c748fd872793a160255cd8e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "774733ffd2f6b7cba3d6acef06a12b180b93b94a8b54b6253783434cfb68125b"
    sha256 cellar: :any,                 x86_64_linux:  "9fa7c8d1eed48ec27f98a40ffc569385618b03fb2eeeaa49672b5360ac8ab1ac"
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
