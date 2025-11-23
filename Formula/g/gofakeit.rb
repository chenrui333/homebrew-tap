class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.11.0.tar.gz"
  sha256 "57ee591f4200745bbc583799d6d9870f032130ce91258c5007984a63713b223a"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d70bb20caa07284329b6d224f2c4c9c196a7a0dfc77366f50fe9a4be08e77ede"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d70bb20caa07284329b6d224f2c4c9c196a7a0dfc77366f50fe9a4be08e77ede"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d70bb20caa07284329b6d224f2c4c9c196a7a0dfc77366f50fe9a4be08e77ede"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "464d5e16b7ff3c20ccb19ee78fd06cdbdc3c25e2c14974c29cf62149deeb9492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c7b2452f489ea66b38049c4476ac30a91b2000ed768ff764c3892526dde90fd"
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
