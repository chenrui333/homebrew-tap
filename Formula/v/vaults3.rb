class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.68.tar.gz"
  sha256 "36b8764f7c68648306f0a234412429fa287680a8e3e1c1a7581d954619053733"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebe82e8f248013b26bbbbb04cc06e16c773388bc7fbdd57fbbfc581968e0067e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebe82e8f248013b26bbbbb04cc06e16c773388bc7fbdd57fbbfc581968e0067e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebe82e8f248013b26bbbbb04cc06e16c773388bc7fbdd57fbbfc581968e0067e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae8b14d044b7a0dce94f32806717c0da7ac3fb98d09ab34b91e65ca9638fe635"
    sha256 cellar: :any,                 x86_64_linux:  "357609515cd98af988c6e44c274d405b94000bee4aa016e9d68f07eb1744b88c"
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
