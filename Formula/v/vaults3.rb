class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v4.4.47.tar.gz"
  sha256 "2fadb17c4ee7c21286375104dd2ee83085a2cc6d698f8ea2fe7d1f780d2961ce"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89339d599be4da16f4737ed07e6c804861f47b8e22bc4182f1000ca1da27bf40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89339d599be4da16f4737ed07e6c804861f47b8e22bc4182f1000ca1da27bf40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89339d599be4da16f4737ed07e6c804861f47b8e22bc4182f1000ca1da27bf40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb7bbbf877f32d596e81d1697ce51ea0cdb4da4edd959c1f72244f088bf5b37b"
    sha256 cellar: :any,                 x86_64_linux:  "4d89b58cab15e51967be3c098320308effc509549b43b05289001c948c26e523"
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
