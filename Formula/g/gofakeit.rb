class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.17.1.tar.gz"
  sha256 "7b2e0a8f04628d78cca3b0787eabbffcdc001f2d313ba0cf5eebf8fe4c9a3031"
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

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gofakeit"
  end

  test do
    system bin/"gofakeit", "street"
    system bin/"gofakeit", "school"
  end
end
