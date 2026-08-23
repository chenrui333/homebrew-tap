class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.58.tar.gz"
  sha256 "aad747e8a701c39608444c30607c7706f124b4558be784aa8e0809109e0b7de6"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe8b8316b77bb87a69750b6f70b4491a1444ce945de1b2d736f1ea3521c64d4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe8b8316b77bb87a69750b6f70b4491a1444ce945de1b2d736f1ea3521c64d4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe8b8316b77bb87a69750b6f70b4491a1444ce945de1b2d736f1ea3521c64d4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e85b54e5d401aaac6487faf3ccdf307a37c225ba8ff75c4b0a7f18e6195e3a5"
    sha256 cellar: :any,                 x86_64_linux:  "445eab2cced8a72ce7882b03868a361a9646d8ff5d3176f538f70ddc801aba1a"
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
