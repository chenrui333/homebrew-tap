class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.44.tar.gz"
  sha256 "7b776bb5a8cdd666982bac02ea9dbf428c2458509ae3e78865829396b69326e8"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dc2fe404edfeb2ac481491f1698d6f09c1cf5083077c7cca747d21345eda0bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dc2fe404edfeb2ac481491f1698d6f09c1cf5083077c7cca747d21345eda0bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dc2fe404edfeb2ac481491f1698d6f09c1cf5083077c7cca747d21345eda0bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79a80e07ff7000fc9cc0729541e364f9baf01008cda63961f3a2913dded3e36e"
    sha256 cellar: :any,                 x86_64_linux:  "cf6c571fc33233a5801097a42d52fa775ab46b3e4cbc05c821c1fcee5f8e4b0d"
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
