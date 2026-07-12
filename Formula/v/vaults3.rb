class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.16.tar.gz"
  sha256 "62e3e5ac60e08f408c952d3530b631c32617dd0765ff839faeda513e36cf975b"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ef2a4ae1daeabee4c55516559c11eb9408585c9eabda1ae1577d3c7e907e5c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ef2a4ae1daeabee4c55516559c11eb9408585c9eabda1ae1577d3c7e907e5c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ef2a4ae1daeabee4c55516559c11eb9408585c9eabda1ae1577d3c7e907e5c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48ef073a9de27f5380dcb766843f01db8db5b6ae6317be651144e29ef3f26aa7"
    sha256 cellar: :any,                 x86_64_linux:  "994e5c22e5a3ec75e6a49ee0f2519091c217f5de120d90b8aedfd6fc6b859f54"
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
