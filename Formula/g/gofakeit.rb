class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.14.0.tar.gz"
  sha256 "98aa4a2228bb7b69027e68c6743ef06b826fdd11f8508138562e36a5bdee6968"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "656f546db17b236db52aeba4cb905ca81439c3e2ad41aa2f6995ef8a4e0b95ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "656f546db17b236db52aeba4cb905ca81439c3e2ad41aa2f6995ef8a4e0b95ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "656f546db17b236db52aeba4cb905ca81439c3e2ad41aa2f6995ef8a4e0b95ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f5d7a5ff2e14083a29b1631eb97f08fc125e1a39b82436f58fab6bc7333a789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b835fea6bafcbc6a7c0ea838fe9e17b7d2691a27ae6fa909b6ef2f00136a6a2"
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
