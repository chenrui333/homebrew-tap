class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.5.1.tar.gz"
  sha256 "2e5ecc6b409f1ed8b84281bc529f6388afc45ddf24ef15c4f4d217dc18605eae"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a804c664b77a22881750c57347e2a96579de4ed5b0cb3e3b407edd31000d0700"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acca8dcf54b81ebb28ae049a18aa7247ea1e59650c2b94973c0b66907b581bd4"
    sha256 cellar: :any_skip_relocation, ventura:       "0be64e4e25795d2f17a1ed9c840ed5ad7c9b2091d5b2affbb97c6b3d2ecc8700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "104b8425ed83125f8faa3637e53b7fb747c68bb5cb08413a5218b9e258980d2a"
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
