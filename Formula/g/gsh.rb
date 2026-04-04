class Gsh < Formula
  desc "Battery-included, POSIX-compatible, generative shell"
  homepage "https://github.com/atinylittleshell/gsh"
  url "https://github.com/atinylittleshell/gsh/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "388dc40c0efde2d1a9fcbaa438569d4d7ab2fbbda41ed00bd56c0397c4dd95d4"
  license "GPL-3.0-only"
  head "https://github.com/atinylittleshell/gsh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9c18376d50a12742dfa28aec3d9c945e02838464d0e5fb711b2c53e6f848a77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9c18376d50a12742dfa28aec3d9c945e02838464d0e5fb711b2c53e6f848a77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9c18376d50a12742dfa28aec3d9c945e02838464d0e5fb711b2c53e6f848a77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26eed9942d0b282ca92b5b770a0c07797d933efc22c15ed8372337baf600c396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12d65a6d8d2dec7caaa79671c004f75431280d9a6006b1de1ddceced3b19d551"
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
