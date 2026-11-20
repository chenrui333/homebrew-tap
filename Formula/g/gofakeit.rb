class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.18.10.tar.gz"
  sha256 "efc37b0f784d543c17b839894755cfb919f119f3318ac8c89ad65ef118421903"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8cb7b32dfc98c1370d74423de4dbae594fc6580215a4df743e9201bc3f89b4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8cb7b32dfc98c1370d74423de4dbae594fc6580215a4df743e9201bc3f89b4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c58c1f9139768ce607a724938867764d507e31f79645c21b6a93c03ea270f21a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6458f166e870d66a00e9268d47bcbe9ea9e3a088eefc948e82883f9eb09f0832"
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
