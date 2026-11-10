class Toast < Formula
  desc "Terminal-based text editor with integrated language servers"
  homepage "https://github.com/paradise-runner/toast"
  url "https://github.com/paradise-runner/toast/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "83a93af895183f1c8c9235d2f4edece0f6ca4b8a745408172c8a3b6cf57e20db"
  license "MIT"
  head "https://github.com/paradise-runner/toast.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54ad3c3e8faa3b01e9d212ba2c40c4e58b5ff15ad279b581746563dd8c02a955"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3229a6762689ab2b1ff7a0c332eab566eef4a66f4f2114c478b67787b01a8b9d"
    sha256 cellar: :any,                 arm64_linux:   "f1112186b45f38d266554a495ef06cb76f2edfdd4292449d0f5fac25232d468b"
    sha256 cellar: :any,                 x86_64_linux:  "33810edc45ba5ed73c2e926a735b2f763ddfd768f155022cd1103b822d4a3409"
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
