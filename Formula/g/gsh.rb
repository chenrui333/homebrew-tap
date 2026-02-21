class Gsh < Formula
  desc "Battery-included, POSIX-compatible, generative shell"
  homepage "https://github.com/atinylittleshell/gsh"
  url "https://github.com/atinylittleshell/gsh/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "1a7b2e74d1a05a59dbcd7b4793d90dabf2f8dd2f527593dea87a3b8e6030874d"
  license "GPL-3.0-only"
  head "https://github.com/atinylittleshell/gsh.git", branch: "main"

  depends_on "go" => :build

  def install
    tool_path = buildpath/"build_bin"
    ENV["GOBIN"] = tool_path
    ENV.prepend_path "PATH", tool_path
    system "go", "install", "golang.org/x/tools/cmd/stringer@latest"
    system "go", "generate", "./..."

    ldflags = %W[
      -s
      -w
      -X main.BUILD_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gsh"), "./cmd/gsh/main.go"
  end

  test do
    ENV["HOME"] = testpath
    assert_match version.to_s, shell_output("#{bin}/gsh --version")
    assert_match "Telemetry:", shell_output("#{bin}/gsh telemetry status")
  end
end
