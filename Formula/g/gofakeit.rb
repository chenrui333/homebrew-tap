class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.18.0.tar.gz"
  sha256 "c7d37b41d394c543ebbd26074bc3cf309f4decab0156d155aeed7852ca9ccf1d"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09c66e52a44087a515d8aae913d140f14826d03dc4f1fbb0b2887f2305d875a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09c66e52a44087a515d8aae913d140f14826d03dc4f1fbb0b2887f2305d875a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf02faeaf82ae7f37ae39a634ebf14962109b01f00f67e9f577ae05a6c7f7a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ff0e0e947ebab3a0f46ab4c7625eef8ce8a34bb881e040d44df976c7199dc2e"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gofakeit"
  end

  test do
    system bin/"gofakeit", "street"
    system bin/"gofakeit", "school"
  end
end
