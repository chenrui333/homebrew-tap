class Toast < Formula
  desc "Terminal-based text editor with integrated language servers"
  homepage "https://github.com/paradise-runner/toast"
  url "https://github.com/paradise-runner/toast/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "7f57f8dc7c3cef0c8612d187a1285cfd34f31af9915e2046fee1897fcd9b9466"
  license "MIT"
  head "https://github.com/paradise-runner/toast.git", branch: "main"

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["GOPROXY"] = "off"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/toast"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toast --version")

    output = shell_output("#{bin}/toast migrate-theme vscode #{testpath}/missing.json 2>&1", 1)
    assert_match "reading VSCode theme", output
  end
end
