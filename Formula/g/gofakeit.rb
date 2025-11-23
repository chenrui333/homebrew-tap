class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.11.0.tar.gz"
  sha256 "57ee591f4200745bbc583799d6d9870f032130ce91258c5007984a63713b223a"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "504a22760654a4a4d65a5f6157018e3ac21ae7633f63317c9302b66ec65a48ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "504a22760654a4a4d65a5f6157018e3ac21ae7633f63317c9302b66ec65a48ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "504a22760654a4a4d65a5f6157018e3ac21ae7633f63317c9302b66ec65a48ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d26f0cfc706021183c2c78c846d9062deeabf3e9847d2cf9178d0bbb0e2b0d28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef9e491e8bda85843429bb9ccd2b3fe21eb4374fcebcb0fccd1045d75177c4cc"
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
