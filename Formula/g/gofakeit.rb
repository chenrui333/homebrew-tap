class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.7.3.tar.gz"
  sha256 "990cac9e91950fb8711aa8cc899514734b4caf0c2eb349f59b2e7bd9d82325cf"
  license "MIT"
  revision 1
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65eae64912be31ad2caf85f29548182b0e034329d9b0cc5a7b3d0068e69053a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7eeba154df5fc68f98acf2f9256a5f3907efb474d57f67620bbe3c2f92384bb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "222f16b595d79f5fb6a7085439dfd853bb010f5b76625f9013b4b66add4c1899"
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
