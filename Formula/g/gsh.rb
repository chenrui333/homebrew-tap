class Gsh < Formula
  desc "Battery-included, POSIX-compatible, generative shell"
  homepage "https://github.com/atinylittleshell/gsh"
  url "https://github.com/atinylittleshell/gsh/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "e82d50c37e53b130e71b4bbc7793650ee72d133eebe3614243e8dce873fdf7a6"
  license "GPL-3.0-only"
  head "https://github.com/atinylittleshell/gsh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c097f6dd74e7a3f240b35ced34111510929597ab18f4eb13eaa0cfb77798ab20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c097f6dd74e7a3f240b35ced34111510929597ab18f4eb13eaa0cfb77798ab20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c097f6dd74e7a3f240b35ced34111510929597ab18f4eb13eaa0cfb77798ab20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7248f6d68662dc3b1e89f2ec0978bea6c0bf3eadc4e45e93239d42bb94683a5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "758c8398fe5ddb7d3cce1e6f077a15da4c3fb96caf95c0a033f6d84df1041af3"
  end

  depends_on "go" => :build

  def install
    tool_path = buildpath/"build_bin"
    ENV["GOBIN"] = tool_path
    ENV.prepend_path "PATH", tool_path
    system "go", "install", "golang.org/x/tools/cmd/stringer@latest"
    system "go", "generate", "./..."

    ldflags = "-s -w -X main.BUILD_VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"gsh"), "./cmd/gsh/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsh --version")
    assert_match "Telemetry:", shell_output("#{bin}/gsh telemetry status")
  end
end
