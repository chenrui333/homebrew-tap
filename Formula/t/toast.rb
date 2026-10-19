class Toast < Formula
  desc "Terminal-based text editor with integrated language servers"
  homepage "https://github.com/paradise-runner/toast"
  url "https://github.com/paradise-runner/toast/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "c1aa313f64b6c3229d440728c7382959b97dc7f4998ef43a73f6aaf9664ee1bc"
  license "MIT"
  head "https://github.com/paradise-runner/toast.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f190c3bc9fc0c574e59b09ff7f1bc16b452f62075060ae25497c2cc8ff39c6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b91af563632324b0d2d0081af3dd70d30a56ea336fcfeb99fe674dce01d55825"
    sha256 cellar: :any,                 arm64_linux:   "858214e5e9a88a447376b64461dab0bb3a3f43b1ea233d573b7b471ab6b49ed3"
    sha256 cellar: :any,                 x86_64_linux:  "1c2c05e1cfe6bf73f4a5505025fa6cec9259d5afd1172c67468169d7d8886537"
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
