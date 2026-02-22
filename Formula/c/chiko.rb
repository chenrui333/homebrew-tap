class Chiko < Formula
  desc "Beautiful gRPC TUI client for terminal-based API testing"
  homepage "https://github.com/felangga/chiko"
  url "https://github.com/felangga/chiko/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "b43b03caf132c0a4455176ee913829fae81fb55d4826848512b391944a36192a"
  license "MIT"
  head "https://github.com/felangga/chiko.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/chiko"
  end

  test do
    output = shell_output("#{bin}/chiko -insecure 2>&1", 1)
    assert_match "cannot use -plaintext and -insecure together", output
  end
end
