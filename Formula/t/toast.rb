class Toast < Formula
  desc "Terminal-based text editor with integrated language servers"
  homepage "https://github.com/paradise-runner/toast"
  url "https://github.com/paradise-runner/toast/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "c1aa313f64b6c3229d440728c7382959b97dc7f4998ef43a73f6aaf9664ee1bc"
  license "MIT"
  head "https://github.com/paradise-runner/toast.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4665a4ae5b44335e9e1f58f25046d4d9b1c48d63bee9f076991b64fe47ccd1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b689681b816fbb993402026bdbdd8c70849fcd190fb95afbc7db62d54d4cadb8"
    sha256 cellar: :any,                 arm64_linux:   "521caccda6100c6cf751c3978dec0ba31df1f5d9f165c0907aae1e68188b9fc6"
    sha256 cellar: :any,                 x86_64_linux:  "eee0f4296c6a4fb02bbee3acb9acc0b11200f4294791321588f35abde46b8105"
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
