class Gsh < Formula
  desc "Battery-included, POSIX-compatible, generative shell"
  homepage "https://github.com/atinylittleshell/gsh"
  url "https://github.com/atinylittleshell/gsh/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "f9902edd46b8232f2a4f965b608180870211ffc3f0c829ff6ee6727ee0da19c6"
  license "GPL-3.0-only"
  head "https://github.com/atinylittleshell/gsh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5799012017aa65c6a9533dbe85ec594e7a2bf0471ff342438ebd455863f2cbe4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5799012017aa65c6a9533dbe85ec594e7a2bf0471ff342438ebd455863f2cbe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5799012017aa65c6a9533dbe85ec594e7a2bf0471ff342438ebd455863f2cbe4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1668e107007c28451d816c66ba7b38e253173168b74b8225f3b283a5d55d8562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61d42571b7dec021dae79435e794fc83af852e698a79e41b25dca3666ef12652"
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
