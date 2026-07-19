class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.24.tar.gz"
  sha256 "7b4373c0aa33dc9b2ff7c29dba73c38c559d81002f2fd5a64c2105dfaadc1c46"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6519a6a0d14e25ce6662262767bcc5f84a03695a7db3aa835901e496f3a2d02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6519a6a0d14e25ce6662262767bcc5f84a03695a7db3aa835901e496f3a2d02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6519a6a0d14e25ce6662262767bcc5f84a03695a7db3aa835901e496f3a2d02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8270858ade9269423b9e518e00be46f8a7d6756585420bd885b1c48b85eb375f"
    sha256 cellar: :any,                 x86_64_linux:  "f783720e2187356673c47381fcc254cfcc2b33e7212dc3a112486b0c230418ff"
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
