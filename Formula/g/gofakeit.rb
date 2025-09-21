class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.7.1.tar.gz"
  sha256 "a0bcb43b870327a196cca0741b0ec14dd95f4020a1653aed7c853e2fb14fe895"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee50c08fd5f25078b1a70c128f6ff1636165c3a9b916dd6af0d98249d9b9f762"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e68a1cd8144aac28227130263e3032a061c10e138d690f39edb7b061d331105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eb0ea2939841f2378519da4dd8432612fa8ea712183ee03caed965945cd1c66"
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
