class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.2.23.tar.gz"
  sha256 "e1a7458b5f6e3101a87241366f1e541c9adbded3a199efcf43fc0a6a2e4f284f"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "063d00a1e5b84807d985a700238b118b61c598f599aa87267db1008a479ef5d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "063d00a1e5b84807d985a700238b118b61c598f599aa87267db1008a479ef5d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "063d00a1e5b84807d985a700238b118b61c598f599aa87267db1008a479ef5d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78b40b697fa196cefb53f14141a0d3fb9a589f1637ef91369ce3006a964cd3be"
    sha256 cellar: :any,                 x86_64_linux:  "1f8c9dccc389c130adf9ebfa099f536934a9147b865aa14a6aacb0e639816db9"
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
