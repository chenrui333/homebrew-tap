class Toast < Formula
  desc "Terminal-based text editor with integrated language servers"
  homepage "https://github.com/paradise-runner/toast"
  url "https://github.com/paradise-runner/toast/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "a083ca7b79b8adcb4781a0b3dc902d362b05aedfec8e99fffb4f5f6ab0461f4b"
  license "MIT"
  head "https://github.com/paradise-runner/toast.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c329f6b10c8bc8b940eb7ab6a614d6f7cffae4fb369fd55fd8b9492771a3c7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e7ff5e0b1e091d11f3209d00af72578ebb395045a06c4fa0e010e61c3d3cf8d"
    sha256 cellar: :any,                 arm64_linux:   "cda4ff8f960a93eba97541785728b68cda5017b5d63e9dd9673771c4956db4ac"
    sha256 cellar: :any,                 x86_64_linux:  "ebd3e27de65209de981d7d4dd124aa031dfae462c2c4665a1c96c1943049c85f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/toast"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toast --version")

    output = shell_output("#{bin}/toast migrate-theme vscode #{testpath}/missing.json 2>&1", 1)
    assert_match "reading VSCode theme", output
  end
end
