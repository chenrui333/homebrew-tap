class Gsh < Formula
  desc "Battery-included, POSIX-compatible, generative shell"
  homepage "https://github.com/atinylittleshell/gsh"
  url "https://github.com/atinylittleshell/gsh/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "3ae7776934e45ae7f47bf9b8201d9243f30d065d718d610c45862d82c1afbcfa"
  license "GPL-3.0-only"
  head "https://github.com/atinylittleshell/gsh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc311995e855ea5d86682c2f46fab08d367c96d9a61c29ea1401a479233ead86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc311995e855ea5d86682c2f46fab08d367c96d9a61c29ea1401a479233ead86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc311995e855ea5d86682c2f46fab08d367c96d9a61c29ea1401a479233ead86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e35cfe7242f26f1d2d85c627cf42538931ebcb178d75eb43de83d4c8d7b6ace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97b053d390103339b622e2dde587299304e8989175c27c9e9af465360bc1fd09"
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
