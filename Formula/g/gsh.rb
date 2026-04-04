class Gsh < Formula
  desc "Battery-included, POSIX-compatible, generative shell"
  homepage "https://github.com/atinylittleshell/gsh"
  url "https://github.com/atinylittleshell/gsh/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "388dc40c0efde2d1a9fcbaa438569d4d7ab2fbbda41ed00bd56c0397c4dd95d4"
  license "GPL-3.0-only"
  head "https://github.com/atinylittleshell/gsh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89eb4b253b1f9a3bc50e196335f105f16445f55050d58f841061053a77cac913"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89eb4b253b1f9a3bc50e196335f105f16445f55050d58f841061053a77cac913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89eb4b253b1f9a3bc50e196335f105f16445f55050d58f841061053a77cac913"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "149e9338a208bcbc6724734e4b5c6f7f495c5077e5e4c81d09a87f558c5ee44a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d2b6f8b69e218b3758f209a2f1602a1bc635f5bb9c584bb601306e102ff85fc"
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
