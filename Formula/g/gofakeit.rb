class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.18.6.tar.gz"
  sha256 "8377bad1e5e21d5640dd05a7943f71a23724f1bfb6ba3c47c88d7cdaa2d0b50d"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "229699ae66249d989a8d5a042ac5ba3f00c2bc8788d191c30b0296023c3a45d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "229699ae66249d989a8d5a042ac5ba3f00c2bc8788d191c30b0296023c3a45d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "468aff60857625baa0492a1d7c6b21ea1fb9b43ec681f3a14f88c79f9d6fdd6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f808dd8c75b4ee68347245b0b9f8337e0448e1cc27b1a700e2eb9bccf856715"
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
