class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.14.1.tar.gz"
  sha256 "47ca51df117de6f4995d586c2b30aa691c5d7f6aa6c42763c6341ae8b6cfa024"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bcb09779cab4c095d59d4017ceac9cf26f7e29394461cf3f6a7df45047a0180"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bcb09779cab4c095d59d4017ceac9cf26f7e29394461cf3f6a7df45047a0180"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bcb09779cab4c095d59d4017ceac9cf26f7e29394461cf3f6a7df45047a0180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed54b4e97c433d47d6f254cd83631ad4275a36779968b7bd97b96d087e89ef53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "597f1ea0bf4c1308946ce1eb0580e15cdf645f94db67ce217614697aa80de1e4"
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
