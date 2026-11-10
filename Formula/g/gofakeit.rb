class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.18.2.tar.gz"
  sha256 "b35d7476ef3ccb0fb2e2e7d19a031d962f6523f06a869ab5e0274b79c7241b89"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbced41f142c568cd8765f58ba9112b7ead6d26d4d967fbeb4e670133f152c7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbced41f142c568cd8765f58ba9112b7ead6d26d4d967fbeb4e670133f152c7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d4a46fe1f999b45b68283592ff980537cf9c0158d466507d0e24b757dac694d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04530f8c1feb56f86142416e8148eb1499d71162ce4b3a8d1ef0fd6d821bb82b"
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
