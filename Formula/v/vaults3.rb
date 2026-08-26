class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.66.tar.gz"
  sha256 "0fb4bcb00ba97a399519ac2b89def18cecfa426e2635195ff8fd979b03e32586"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b1330fa3eab4f8e356275b1f80fec5143d5b5517911e7c640c988397fb78578"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b1330fa3eab4f8e356275b1f80fec5143d5b5517911e7c640c988397fb78578"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b1330fa3eab4f8e356275b1f80fec5143d5b5517911e7c640c988397fb78578"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc096765fa627fbab0720145744684a8fb1b5d0a053284ff8be49b7642fae339"
    sha256 cellar: :any,                 x86_64_linux:  "2ffe96f2c4c1c2f62d87b1a908d75346905ac3253dde838c2cd8f56ba85839fb"
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
