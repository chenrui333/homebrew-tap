class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.3.tar.gz"
  sha256 "a76f085a1710fdc10c8c4415790e9b60ac831804635b2ad15e75fa56ee0b6b5f"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ddd3e67844aabfb93b84de4a410bd42513d6659682f45c05a93af5ce62e1f00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ddd3e67844aabfb93b84de4a410bd42513d6659682f45c05a93af5ce62e1f00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ddd3e67844aabfb93b84de4a410bd42513d6659682f45c05a93af5ce62e1f00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f21365600853954f1065495377fcf76dcc79cd42f2d22700815dc3f7c8dd0250"
    sha256 cellar: :any,                 x86_64_linux:  "314bff08b56091b392d008ed26344574829b0f42e3efad4e84766651bc2fca14"
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
