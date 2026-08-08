class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.51.tar.gz"
  sha256 "4747f020c16cc13597a68fcb088bc61c03a0ac6cf3e910ca13293addf6ea5bff"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf7ce2535a19ad32a7394edb1d64e0bd02dcd80660836339befcdaf956cdc534"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf7ce2535a19ad32a7394edb1d64e0bd02dcd80660836339befcdaf956cdc534"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf7ce2535a19ad32a7394edb1d64e0bd02dcd80660836339befcdaf956cdc534"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5645bf63b1769b5eda5d6d7ebd60411553173968c01efec25fd5c25537c50be"
    sha256 cellar: :any,                 x86_64_linux:  "3bb0592e7762f9755beb9f5ad8e0f0b28234bea5e231db3dabf2bd61d99036d7"
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
