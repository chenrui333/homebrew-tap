class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "7f7154956eaab3e0ea4a10bb19872406a1a400f0ff65977c908ecbff0c1b0435"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17571a7490c59c1639814563299aa2d5021b611f22f0e9975fdbecc8efaad2c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17571a7490c59c1639814563299aa2d5021b611f22f0e9975fdbecc8efaad2c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17571a7490c59c1639814563299aa2d5021b611f22f0e9975fdbecc8efaad2c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1da03ab8f7537bc460e71333c4b2b567d38fc5061162e99aafb98a0cec4c2a54"
    sha256 cellar: :any,                 x86_64_linux:  "352f84f8bbf6a5faad610173f8a344586eea65cef055f78d03435dcaf1a939c3"
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
