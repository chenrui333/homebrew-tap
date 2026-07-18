class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.22.tar.gz"
  sha256 "570506f4a280f530a14fcc96401682bb6617dc1d47cdefb3d9a7e39a246ba85c"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "826f1e3eed9639a87106a1f8746644f88c7cdc7fe1b1e2c94d8d85f8c3495781"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "826f1e3eed9639a87106a1f8746644f88c7cdc7fe1b1e2c94d8d85f8c3495781"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "826f1e3eed9639a87106a1f8746644f88c7cdc7fe1b1e2c94d8d85f8c3495781"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed757c09ec832c7c09ad21af794f0a22ad9d8e57da6c889a0748cea65eb53e7b"
    sha256 cellar: :any,                 x86_64_linux:  "e9a52a3101c4800e76e83d44d0816d1acac3041f404894660438a4caf3e7e1e1"
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
