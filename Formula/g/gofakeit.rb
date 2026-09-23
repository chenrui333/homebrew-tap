class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.17.1.tar.gz"
  sha256 "7b2e0a8f04628d78cca3b0787eabbffcdc001f2d313ba0cf5eebf8fe4c9a3031"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b67765b03ba2b8e53294d8af69be05c73f8a0aadbafbb5660a3a373f0704eb8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b67765b03ba2b8e53294d8af69be05c73f8a0aadbafbb5660a3a373f0704eb8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b67765b03ba2b8e53294d8af69be05c73f8a0aadbafbb5660a3a373f0704eb8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "677e6d495cc1b775a3ac5e3b57ac00193ff5c184949f12e1e3e964b05de196e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d729565abcb318c299eeec3c76315e22e706f15dd04d6a37f3eb1a2fe0a64cb5"
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
