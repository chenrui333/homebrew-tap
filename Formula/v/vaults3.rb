class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.35.tar.gz"
  sha256 "dfa438cf89bc331b49bd6377bf659fb051472d4e2a88818de2370124d1d6e682"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "007a20305e40b3f38c4399b85d1fe4abe2c0d8e2678e3446372afc4626f93b92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "007a20305e40b3f38c4399b85d1fe4abe2c0d8e2678e3446372afc4626f93b92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "007a20305e40b3f38c4399b85d1fe4abe2c0d8e2678e3446372afc4626f93b92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0342bd4674ba0d13644734185499873077ba2ab5b162e0cf656e7ab13745442"
    sha256 cellar: :any,                 x86_64_linux:  "1e536f0d04a0455262f2979446b743b3b5f8cea09b5a5b6de031b113699ceb38"
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
