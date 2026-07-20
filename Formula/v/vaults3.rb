class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.29.tar.gz"
  sha256 "c87143ba644f683cf1252c3c6d5d83b259b4255a054bf3978a7493a8c22792c2"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4bae7c0b7336a345cb8e25eb4abb9d69ffab0191a9fc1a3d40334a5aef7760c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4bae7c0b7336a345cb8e25eb4abb9d69ffab0191a9fc1a3d40334a5aef7760c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4bae7c0b7336a345cb8e25eb4abb9d69ffab0191a9fc1a3d40334a5aef7760c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4dcd1999044a44a5508ec4bb21a5be91664f7595bba7a692ef55bcc78c62c3d"
    sha256 cellar: :any,                 x86_64_linux:  "3ecb0ad458a3885564c8e2df20c9f9dd9b857957a0b0055aebd6259871e39a5e"
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
