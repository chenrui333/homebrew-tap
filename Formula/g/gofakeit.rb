class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.2.1.tar.gz"
  sha256 "5fb31ce19e9a7a6b6627059b6f9f2d7b451c22034fce1c9ee40c8d404a1f50b4"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b271ab83a3b1830c487902dd4ab352ca3ff503a72dcd6efdb405ea8b9277d3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f86a78db71b11ce54bad47d6bff1a2fc3ede07b83b6082a34377e7137cff9d39"
    sha256 cellar: :any_skip_relocation, ventura:       "3bf60d40fb5130982f25d01c52c3763dee225baeb13daf47377e2d8fcb379cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57869bd2c4197d62693e1c11268c48b0db5d153efa405e1dd807d1b32a8d637e"
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
