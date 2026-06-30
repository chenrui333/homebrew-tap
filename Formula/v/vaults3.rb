class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "8397b01ec4cf127c7857c4530a9ad7a0a01f89bc0aec5ab70144885303d775c1"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51c641cee1760891ae19fcf64f7c26137975975abf89d2198b41cfc260bbef41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51c641cee1760891ae19fcf64f7c26137975975abf89d2198b41cfc260bbef41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51c641cee1760891ae19fcf64f7c26137975975abf89d2198b41cfc260bbef41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "875e2dd69201b973af0d380de3b376c73e240b491239cb7689036f76fb0c8c7f"
    sha256 cellar: :any,                 x86_64_linux:  "024214523238faae667dfe76139ba3cf8ed79f1813e0c11eefe24b7243667676"
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
