class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.2.15.tar.gz"
  sha256 "c8652729f0b9690e11ac52e854066fbf9e7988e81fbd8db357b881792d43ca08"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d7647570e8354b6c8baaf103490214c472db81e7b50ce85ae6d0c7cdc4e39f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d7647570e8354b6c8baaf103490214c472db81e7b50ce85ae6d0c7cdc4e39f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d7647570e8354b6c8baaf103490214c472db81e7b50ce85ae6d0c7cdc4e39f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55879380f71a8d012b40fb7ef6bcd17db559ac40b77964cb9ad46c03699f4432"
    sha256 cellar: :any,                 x86_64_linux:  "c383bb292c9ea78ba7e96c44791a2f77b8eee02975b6f5218061552a80a8c06e"
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
