class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.68.tar.gz"
  sha256 "36b8764f7c68648306f0a234412429fa287680a8e3e1c1a7581d954619053733"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3d409f26c3111fd75d0bc9a33764e0fc2f77b11464a7b27dfe33845574c792f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3d409f26c3111fd75d0bc9a33764e0fc2f77b11464a7b27dfe33845574c792f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3d409f26c3111fd75d0bc9a33764e0fc2f77b11464a7b27dfe33845574c792f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc8eea48a76e97fd00153a199a8cfeb5eb2930cd85fcfa870dfc04e19985c758"
    sha256 cellar: :any,                 x86_64_linux:  "cbb65840666f40ebb8642d4d028e8640c84c3bb4b14d0d4cc9a161b90e7fb727"
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
