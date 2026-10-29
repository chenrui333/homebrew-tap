class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.18.1.tar.gz"
  sha256 "f6271c074c2b12fdff11dca58365b98e19c8bb9fba3678441e950c81f36e30a0"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7da3e6d5143869cc34fcb6878b8cbd9b3ffac01d7a1d74d88cce4c4e71f407e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7da3e6d5143869cc34fcb6878b8cbd9b3ffac01d7a1d74d88cce4c4e71f407e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb71fe62f456834e07960f4cbe57cc2c8bf0665fbdbbb196fd04ed1395830d4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aa88ecd4ff5bc4f1338d98c0fe61d4e7635a58cabd933fc14fd2bcccafd3746"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gofakeit"
  end

  test do
    system bin/"gofakeit", "street"
    system bin/"gofakeit", "school"
  end
end
