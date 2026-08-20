class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.16.0.tar.gz"
  sha256 "551871ba4fc3490c912a3eb2d0020bd1e7b9c7b42e07777622c4c2f6e241dbb2"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91e184ddb388a902e9fadac2f8afddeb33abd3031f1a1a3e1ac1fbb838dd8ae4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91e184ddb388a902e9fadac2f8afddeb33abd3031f1a1a3e1ac1fbb838dd8ae4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91e184ddb388a902e9fadac2f8afddeb33abd3031f1a1a3e1ac1fbb838dd8ae4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e25c2a5ad654da53859db030edc184f58543f215af2a35a8710f5f413a2e2b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6d1e186a876b150863dc812f031448149a81dbc00a5a352c7e8fb08d8d2df95"
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
