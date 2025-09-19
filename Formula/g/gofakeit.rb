class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.7.0.tar.gz"
  sha256 "ebc0e53254db6f41ab265fd8f18197ebb2720e74f6e107e7fbb670cb7b953d2f"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a793cf7fbf73d10cc8fa9c8c74b741f0916dc4b37e5bedd409c0fb91028618c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd09a477f1cc66f9a6b49028308afcb1413184793f2170feff5959b431866d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea0d17064fce3bcbc8c429bab7b320b828725f8cb066ab6109a86ff74059456e"
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
