class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.7.3.tar.gz"
  sha256 "990cac9e91950fb8711aa8cc899514734b4caf0c2eb349f59b2e7bd9d82325cf"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18438ec255777f89266ff3a0c782b183c2a46174ebfdaf4dc3c216e1d3817076"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e765cb950e762a34fc30fe590aed98ebc90a71cb19858b75657ca75dfcee6e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6263c4b9d09bdc09883ed231deac892e6b44e36c218f73394e792f6e4005fbe4"
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
