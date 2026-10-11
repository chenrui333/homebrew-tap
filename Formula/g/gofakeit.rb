class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.18.0.tar.gz"
  sha256 "c7d37b41d394c543ebbd26074bc3cf309f4decab0156d155aeed7852ca9ccf1d"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a84446c7c6f3c502fb6e2b90fc4e7a05abb285f8d526e7d1b818a205bf9d49c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a84446c7c6f3c502fb6e2b90fc4e7a05abb285f8d526e7d1b818a205bf9d49c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8170315ca5a869039eeac385460cc2a706f8fb04455a55e8adcfac112f298fe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65cb33b6d5fc064b0ecdb3df95c8170d5af6a5f204175ef3392369d5e5d76827"
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
