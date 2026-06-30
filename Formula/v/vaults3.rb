class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "2005028a277e0e63e66df475e11457d1e320222a2bfd70d9a06815e287805fdb"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e779e353a94d4515739cd40042b2834651aa6159620e60e1b1ea40eed81ca232"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e779e353a94d4515739cd40042b2834651aa6159620e60e1b1ea40eed81ca232"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e779e353a94d4515739cd40042b2834651aa6159620e60e1b1ea40eed81ca232"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d732539091ce059b490e42d727b8840e37137c8a2734af049cbcd44dda1a4e6"
    sha256 cellar: :any,                 x86_64_linux:  "717dbad69c67a1d1c4a7b6126d5e4711490d58fc6f80f62514f7af21811a57fe"
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
