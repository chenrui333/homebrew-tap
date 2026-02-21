class Gsh < Formula
  desc "Battery-included, POSIX-compatible, generative shell"
  homepage "https://github.com/atinylittleshell/gsh"
  url "https://github.com/atinylittleshell/gsh/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "1a7b2e74d1a05a59dbcd7b4793d90dabf2f8dd2f527593dea87a3b8e6030874d"
  license "GPL-3.0-only"
  head "https://github.com/atinylittleshell/gsh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f577365d4f38eee3a212f62920e02ebdbe1f1c74eea4f3d99867eda5061ec923"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f577365d4f38eee3a212f62920e02ebdbe1f1c74eea4f3d99867eda5061ec923"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f577365d4f38eee3a212f62920e02ebdbe1f1c74eea4f3d99867eda5061ec923"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a4da3a4df09b06c044e5134752532ba1cbd778285c290d1cb94d5f85f7fe294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4bc6d9653ca9ccef1f521f1b37548e6cf36080c35cc50588d225e460711b5af"
  end

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
