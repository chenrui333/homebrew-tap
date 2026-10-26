class Toast < Formula
  desc "Terminal-based text editor with integrated language servers"
  homepage "https://github.com/paradise-runner/toast"
  url "https://github.com/paradise-runner/toast/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "a083ca7b79b8adcb4781a0b3dc902d362b05aedfec8e99fffb4f5f6ab0461f4b"
  license "MIT"
  head "https://github.com/paradise-runner/toast.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9af27ab24da9ef49c642e71d086e9583214d2f2c73188de17e6e4849dfed611e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1de206b9b29c793794c30aaebfc450133318c57a5efe263b5e4fe0063ad2c0e0"
    sha256 cellar: :any,                 arm64_linux:   "2139528f7002d0f3b38ae6ba9e71c087770ad0de16ccc5d9a563d53a3c8c23cb"
    sha256 cellar: :any,                 x86_64_linux:  "48a11ae57403cfa392e9e2d97f00602d81f7718b80a926a15417b379cd0bac82"
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
