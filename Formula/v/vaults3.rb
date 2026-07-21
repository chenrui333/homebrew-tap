class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.34.tar.gz"
  sha256 "704e3ff9589c0cffee2d6b27287f6fc636ca7884393d917928243debeed1fabc"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8d7d41e895207c4b56898000ec085803d8293b4d0265f7d12fbb4cd5cb211fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8d7d41e895207c4b56898000ec085803d8293b4d0265f7d12fbb4cd5cb211fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8d7d41e895207c4b56898000ec085803d8293b4d0265f7d12fbb4cd5cb211fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "641db4823123be605c13d7200dfd1b9f74d515dcfa540d9c2478390ddd930ce5"
    sha256 cellar: :any,                 x86_64_linux:  "994bc2348f3db24dee6c65cd05e17f3b211eb12ce68dcb1c21bd84468da5434e"
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
