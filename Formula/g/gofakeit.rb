class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.18.7.tar.gz"
  sha256 "5c572806bfde7ef10e8501525b92217105689052bd700a63263bf6dad7c94c91"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "742d9433e538e96e40e222d986732ff8fbb76f8dba3414ebc541c30ec386a847"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "742d9433e538e96e40e222d986732ff8fbb76f8dba3414ebc541c30ec386a847"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b403b7174b101020d8962435b80b4d4a1039ebe6c8e5a0f41740578aeded592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf925ada7dbde301fff202688850b8479c66c9a2dcefc891e6e117cd3fc93afe"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args, "./cmd/gofakeit"
  end

  test do
    system bin/"gofakeit", "street"
    system bin/"gofakeit", "school"
  end
end
