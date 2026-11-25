class Toast < Formula
  desc "Terminal-based text editor with integrated language servers"
  homepage "https://github.com/paradise-runner/toast"
  url "https://github.com/paradise-runner/toast/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "9f2123cca3082f410e7b69ef9866d457ce97d74fab03247dd9a1f74159d2eeb5"
  license "MIT"
  head "https://github.com/paradise-runner/toast.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "742fa55a39c7f14ff865fb2ea2c0a8460e57d07cbaf538b2a5d4febd7ffc237e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c054ab1582a2eaa710d8130ffc2acde3701c7ce888e2a45753772a9f2101e06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9a548e8bb615b111c23a51758834d96089fee35038f1a9a90e61588f00d690b"
    sha256 cellar: :any,                 arm64_linux:   "df9fcdcb1b7d60c0791e233b1f310b2e4a12f61fcd6d49d275fbb6e61cce15e7"
    sha256 cellar: :any,                 x86_64_linux:  "4c0be4cce18ac5b0b89102f0ed6b27c0c969bb1df021e1e64e5171701ce4cdd6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/toast"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toast --version")

    output = shell_output("#{bin}/toast migrate-theme vscode #{testpath}/missing.json 2>&1", 1)
    assert_match "reading VSCode theme", output
  end
end
