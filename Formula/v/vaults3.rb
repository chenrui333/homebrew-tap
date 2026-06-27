class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.2.4.tar.gz"
  sha256 "918a42c8fa14080d34d73a119440c5bc9b6d9bd7da6a84669f404a87503c68f6"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0166067cab580eca93cade78c20270a8753eb10a16f31c047a2e8ea53b7064bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0166067cab580eca93cade78c20270a8753eb10a16f31c047a2e8ea53b7064bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0166067cab580eca93cade78c20270a8753eb10a16f31c047a2e8ea53b7064bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de6b56ab997e5d217d764a56ed8ec6ea36b53ac85c6b19c0dba9e9230a7b2fbe"
    sha256 cellar: :any,                 x86_64_linux:  "b668d46d957f0aa9ef8d50cb499f7c3adc686655c68692416bc2cf9aee69ab21"
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
