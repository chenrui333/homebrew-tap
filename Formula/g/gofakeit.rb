class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.4.0.tar.gz"
  sha256 "731a263c0ef212b1d4fd53acc5075a805a60781f1d3990185e53c5dd03445dc1"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86d7fe692b1fed5b1a5910e588ed5f57d60699a00db53d873d9d78cfa860dd6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3292983ce501767edaaac537a08200ad52da1642b85719590e1fbefe41f2b0cb"
    sha256 cellar: :any_skip_relocation, ventura:       "370ccbcd03b6ed8cc7d48949433b3c332dcb643114479af31fa85ed10fbf18a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bda34bb79076daaf8d1f336bbf9670281706fcb281afe28442f10e53d4c063f"
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
