class Packemon < Formula
  desc "Terminal tool for generating and monitoring packets"
  homepage "https://github.com/ddddddO/packemon"
  url "https://github.com/ddddddO/packemon/archive/refs/tags/v1.8.25.tar.gz"
  sha256 "4ec19a63d155c7e7854608e9813d53a01631308369dea5d387d69f0705258616"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/packemon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5695a0e4627ed6ecdc664898d104bb9572de747bdcff921c154a2e8b81155c85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "962848605b6f02c2822f685d54c12290e45624e89d048d5603219c8619eb068c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59b1be6e36391e500ed9898388bcf4384592739af5e3df22b26c0ebbc42af52a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "216132bbd1e5e3a98ac7e8408e51cd698f65a275e62d13af2fb0ebd2ac28bdec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44f517609a581cd20f669dc8988352c13fdcd81de270f3bcb2a0869c9314aa30"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=brew"
    system "go", "build", *std_go_args(ldflags:), "./cmd/packemon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/packemon version")

    interfaces = JSON.parse(shell_output("#{bin}/packemon interfaces --json"))
    assert_kind_of Array, interfaces
    refute_empty interfaces
    assert_kind_of Hash, interfaces.first
    assert interfaces.first.key?("InterfaceName")
  end
end
