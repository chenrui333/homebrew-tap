class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.2.20.tar.gz"
  sha256 "11c202a038736f96f92a68acd6230334083fb729397caa77079a80a29dd70c54"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "effeb8105fe9d2e89a00c3b1e4d42e90fe3bc4a62a5b293f7b638007a24e73e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "effeb8105fe9d2e89a00c3b1e4d42e90fe3bc4a62a5b293f7b638007a24e73e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "effeb8105fe9d2e89a00c3b1e4d42e90fe3bc4a62a5b293f7b638007a24e73e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aaa09b478b9281ec0fce34d762277396cfcd3f55e82c3e5e767ff2e8f42b0ac"
    sha256 cellar: :any,                 x86_64_linux:  "8e049168ec51503ed4590c7857f858b5f3fe4ea32870573ef85e9fb0bbafaba0"
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
