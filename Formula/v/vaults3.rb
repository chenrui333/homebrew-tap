class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.26.tar.gz"
  sha256 "e212da040156c9e7b70f796533fbfe224f1abbfe99b7bd2812988d6c98590cee"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0606e8ea6b90103c3f9ac9235085d92a30d18ad5b658cf4d6e1d502545f4bcb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0606e8ea6b90103c3f9ac9235085d92a30d18ad5b658cf4d6e1d502545f4bcb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0606e8ea6b90103c3f9ac9235085d92a30d18ad5b658cf4d6e1d502545f4bcb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e20a0710fe4dd7b0878c6cae62a44abf915a36b30f9c6d7796a364abcbd9a3b"
    sha256 cellar: :any,                 x86_64_linux:  "79514b0b54d98ba595fda72e198e8fe5d28c2d745ed140b3e09f1f6c9eeb8dac"
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
