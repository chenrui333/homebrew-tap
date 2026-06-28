class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.2.12.tar.gz"
  sha256 "3392b5e4d2125eb9c3784716998229b589e4703f648c0371e57b561ed818dcd8"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81bc19b311da57d73f979a8ccc2c3a34a05fbea69d6242d1cbe96963d4d62d1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81bc19b311da57d73f979a8ccc2c3a34a05fbea69d6242d1cbe96963d4d62d1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81bc19b311da57d73f979a8ccc2c3a34a05fbea69d6242d1cbe96963d4d62d1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a73b1959fb19f36653a798ea6c9f6da225b6289324c316e04e765d7189671c17"
    sha256 cellar: :any,                 x86_64_linux:  "de35b4ebf56660469f9911a484677cccd01fe465aca840f19066a580fa9251e1"
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
