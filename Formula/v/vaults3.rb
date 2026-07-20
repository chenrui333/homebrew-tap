class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.31.tar.gz"
  sha256 "5e292794f73c0d80437cb0fce11b317f2a1b6c3172590d7df2db323f7c810827"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62d7cc0682504f62cb526dd45686a54c7fb88825375cc471634143183a17c9a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62d7cc0682504f62cb526dd45686a54c7fb88825375cc471634143183a17c9a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62d7cc0682504f62cb526dd45686a54c7fb88825375cc471634143183a17c9a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eac6cb76df52e501d845e0c675f1d65f2bff467061ddabe81140b052a2db788"
    sha256 cellar: :any,                 x86_64_linux:  "8fcaf980f3a6af0054ed04817983c85ab83aa2202ff5409697fa66ffe5986a36"
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
