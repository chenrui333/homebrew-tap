class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.2.19.tar.gz"
  sha256 "f2b2cdd6751874500d6b6b4d68ead5cecaa82e7d5584640276a70c9ac06821ea"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f384ca4d0259e4ea475e2c2a0e700125383578747187ef560f092e678cb6069"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f384ca4d0259e4ea475e2c2a0e700125383578747187ef560f092e678cb6069"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f384ca4d0259e4ea475e2c2a0e700125383578747187ef560f092e678cb6069"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7ed3f73418db08f7235c4509a4af6d8a127d4ba766af63e2218509ce92c22a9"
    sha256 cellar: :any,                 x86_64_linux:  "a91b94c5260b781612f3ae542ac8e2eb0f8b148f19f56229c4749ce272503bff"
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
