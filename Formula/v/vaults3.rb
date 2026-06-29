class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.2.21.tar.gz"
  sha256 "3793911f31a599b17ac510c2530abeb0b42f525fee0c62f65aa808a321b9b782"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37c7201e24af85cb8acc0246d145cb47c2ceb4076ff35c266f424bf4381a5038"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37c7201e24af85cb8acc0246d145cb47c2ceb4076ff35c266f424bf4381a5038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37c7201e24af85cb8acc0246d145cb47c2ceb4076ff35c266f424bf4381a5038"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b604b296134b66059c3c6cc368ee6b01916587d49208dd306d4ad3dec63ed8b9"
    sha256 cellar: :any,                 x86_64_linux:  "a7c02b501c84b186af421ff1867fcd40de5785a8d35536ffe06fa94017ae0402"
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
