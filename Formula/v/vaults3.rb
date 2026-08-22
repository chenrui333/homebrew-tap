class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.55.tar.gz"
  sha256 "270c6dd6cd9451373adae74b03f4391dcb06c8e3b6797491e7bfb4d714df709c"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "983b3ecfd84e12a865dccf177b73d21be894325e417ace4900bc2dbca20e258a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "983b3ecfd84e12a865dccf177b73d21be894325e417ace4900bc2dbca20e258a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "983b3ecfd84e12a865dccf177b73d21be894325e417ace4900bc2dbca20e258a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d89bbb9565ce80ae8244f1f08b331103e2c8f95a03071e4539d7b0b77c00227"
    sha256 cellar: :any,                 x86_64_linux:  "302fe7b2cc75aaba9c9d14daf8a8d9b8de05776e0c78f99bc6d6c56735c917a9"
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
