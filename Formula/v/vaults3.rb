class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.54.tar.gz"
  sha256 "8db86761d832c26dde9b9f706aac09b7456d7617c12547a7d4478128dd542842"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a5c02a945ea591b6f0e7f5e4f5f0552875ebbe5be88689bdf935122bed702a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a5c02a945ea591b6f0e7f5e4f5f0552875ebbe5be88689bdf935122bed702a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a5c02a945ea591b6f0e7f5e4f5f0552875ebbe5be88689bdf935122bed702a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63f5b0474370d1dfd54ebd99bc2c8b8d754548f895120ef44bffbe09a9673aee"
    sha256 cellar: :any,                 x86_64_linux:  "740f06d757ed6b5db114d2313a2378f1b75c570440b05a257d9b4d025b9ef7d7"
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
