class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.12.1.tar.gz"
  sha256 "a242a30e501f460910abcc63e2367459ecf41f3f7b6c6f849284bbb3dafff3ad"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a79cecacd6d8c0c19cecc44fafb77ecc310372ef0ef7895f8ecced1c631be9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a79cecacd6d8c0c19cecc44fafb77ecc310372ef0ef7895f8ecced1c631be9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a79cecacd6d8c0c19cecc44fafb77ecc310372ef0ef7895f8ecced1c631be9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e16b188ebcc1745640d3063fc459b43d0bffde60e592c91d09bba8be8c48b81e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d2aab84a51d62b96c8feba783b65a28c9ad083bb054bb6921461f70ce772b6f"
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
