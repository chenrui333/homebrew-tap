class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.63.tar.gz"
  sha256 "8c355f927b2c6aeb67040624fd916c234bfd7a299ad3637686ea1a4ee37f33cd"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f152cf25ffdb62dfb635df070fcc2279aea4fe3fcef7302f18cdba46b558499"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f152cf25ffdb62dfb635df070fcc2279aea4fe3fcef7302f18cdba46b558499"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f152cf25ffdb62dfb635df070fcc2279aea4fe3fcef7302f18cdba46b558499"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e0a3faf3fe259992cfedb6bdb00b7fd9675955e280bfcc0d725720711fc4276"
    sha256 cellar: :any,                 x86_64_linux:  "b99db87e0f9a1bd32b80fecca983e96cae0c2bd3a676cfe1f206b2d8bca6fad2"
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
