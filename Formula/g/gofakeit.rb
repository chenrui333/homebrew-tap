class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.18.6.tar.gz"
  sha256 "8377bad1e5e21d5640dd05a7943f71a23724f1bfb6ba3c47c88d7cdaa2d0b50d"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a6e1d3c33a01aade9a76843f751b0a7bd0a9246afbfe7595a798129de6f298d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a6e1d3c33a01aade9a76843f751b0a7bd0a9246afbfe7595a798129de6f298d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb6ff05fe15172604d266dada25b03bd67cde72d470077fa8fb653a5b7780603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c3049e2e3709bb77b3a90a787a88ea907ffe8156c6aa32c0a1417739a6953ca"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args, "./cmd/gofakeit"
  end

  test do
    system bin/"gofakeit", "street"
    system bin/"gofakeit", "school"
  end
end
