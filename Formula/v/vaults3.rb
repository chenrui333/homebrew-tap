class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.53.tar.gz"
  sha256 "39541fb7689b7db2f249c6653195a5dfb6787860955a6d8444ff81fe094987e7"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef05e638575d22fb7e6be5a0d53b7b3ce4e582fcd5fdbe54cd5372e19eb82714"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef05e638575d22fb7e6be5a0d53b7b3ce4e582fcd5fdbe54cd5372e19eb82714"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef05e638575d22fb7e6be5a0d53b7b3ce4e582fcd5fdbe54cd5372e19eb82714"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da2ace92b042923a92f5c14ddf7786744bc10fa7610a5ddc5309f09278d50478"
    sha256 cellar: :any,                 x86_64_linux:  "7b925ec24f4b1fe3b18e5f060670cbbfe5899b9f05d193c3065b230fd812a4b7"
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
