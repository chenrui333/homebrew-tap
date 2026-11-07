class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v5.0.8.tar.gz"
  sha256 "0299746c292b51b5e24b520c7b9998ee96970a1730272c0e4f945600f7b32600"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "549ee106f2d9c48c315c3a076d20f6ff06b66adbfc6414cc553a4e4df1ca6f43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "549ee106f2d9c48c315c3a076d20f6ff06b66adbfc6414cc553a4e4df1ca6f43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61ab1c4832484eb7cdd4bbbcb99f30d200f26bae41d9d55e95036886fe4b2f5f"
    sha256 cellar: :any,                 x86_64_linux:  "2f0d4d3d4ffbbb9387c98c5d9da4e0e35b62356cda74c66a75b21de49b532899"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  # vaults3 is an S3-compatible server; the test queries its loopback health endpoint.
  allow_network_access! :test

  def fetch
    cd "web" do
      system "npm", "ci"
    end
    system "go", "mod", "download"
  end

  def install
    cd "web" do
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

  service do
    run [opt_bin/"vaults3"]
    keep_alive true
    working_dir var/"vaults3"
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
