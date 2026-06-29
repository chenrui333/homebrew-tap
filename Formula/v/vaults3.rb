class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.2.18.tar.gz"
  sha256 "c7ca74253a80aa2ff0cdedf92fd02e0c4759c2c7d63e7e8b88d28613cda71a9c"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fca7dcbc4774ddcd4be43d77ff78163a24d52c70dca4cea9c2d774d32c809afe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fca7dcbc4774ddcd4be43d77ff78163a24d52c70dca4cea9c2d774d32c809afe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fca7dcbc4774ddcd4be43d77ff78163a24d52c70dca4cea9c2d774d32c809afe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26e63576c75d8d207366d45d67bb0acc6a23db4e444a16ac217c0638d0972d49"
    sha256 cellar: :any,                 x86_64_linux:  "2a7fbd9104a65c5cdaf4a79abcd0ae441e3f749f04e0c5fd75c61dfe02bccf59"
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
