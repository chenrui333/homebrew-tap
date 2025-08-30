class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.5.1.tar.gz"
  sha256 "2e5ecc6b409f1ed8b84281bc529f6388afc45ddf24ef15c4f4d217dc18605eae"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a573f8e42ceb0687a08cd26149043f6fc4ab9c72c770f3143d7262ce16dd2169"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d873c2f3028d549861d03ffc847bbe43d4ce9f9499e793acd3ddfb8f9943783a"
    sha256 cellar: :any_skip_relocation, ventura:       "895537a0b9ddd57dc46fd043758f21afd57b9209f6277a7bbe638160e1b02477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de0bd5c9bb81708a68d38f1e0ef9b49c17e9deb41f32360a4424abe7551b0aa3"
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
