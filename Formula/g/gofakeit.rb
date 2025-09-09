class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.6.0.tar.gz"
  sha256 "249a4443c83f7811dc06d915588cb3bf3b6c55dc9bd6cb3e9ca180a93f03c634"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba4176e11da9dd926cedfd9a2bb3c7b0ab523f20ea9ff39492f0eb1825c39b67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef8fcfb195d539e5f94b71093d60ca01db9836021a3619e95d4091ad81fe8162"
    sha256 cellar: :any_skip_relocation, ventura:       "0826257e62f9b62f812b7c35ad0b590aba14a7567b8dfac6e383a2f5280da156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8686dbd405ee73c301e5d0ee2deb34975eff7ae94de150d4d0214cfff30a81d6"
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
