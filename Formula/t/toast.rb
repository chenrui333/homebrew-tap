class Toast < Formula
  desc "Terminal-based text editor with integrated language servers"
  homepage "https://github.com/paradise-runner/toast"
  url "https://github.com/paradise-runner/toast/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "7f57f8dc7c3cef0c8612d187a1285cfd34f31af9915e2046fee1897fcd9b9466"
  license "MIT"
  head "https://github.com/paradise-runner/toast.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47cafb3a91be4f9168a1e56e76186c1bf257fafe16db6b3fa0326319a5e58300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9a6e3024156d519ce7f9bd94a85769712355e832a8b79e94410d767b080702d"
    sha256 cellar: :any,                 arm64_linux:   "f10fe8cd72870f1ab93c7392a92b22f9d8dc50553a0b414405bac67f7a642056"
    sha256 cellar: :any,                 x86_64_linux:  "90f4ac402e31ea9753b7c97b0836dd3b8302dbd8d932c7402d2077f645e17793"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    ENV["GOPROXY"] = "off"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/toast"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toast --version")

    output = shell_output("#{bin}/toast migrate-theme vscode #{testpath}/missing.json 2>&1", 1)
    assert_match "reading VSCode theme", output
  end
end
