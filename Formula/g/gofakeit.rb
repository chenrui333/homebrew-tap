class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.10.0.tar.gz"
  sha256 "5c2547035fb84c60307f3a9aa34fe19f56e72bc5561c742261f8999488dbcc32"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c67ad4435589a349ac0ecf8ecd18a9e9ab4cb9d7f1af1056827b7deedab37c57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c67ad4435589a349ac0ecf8ecd18a9e9ab4cb9d7f1af1056827b7deedab37c57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c67ad4435589a349ac0ecf8ecd18a9e9ab4cb9d7f1af1056827b7deedab37c57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b52eb9a166912200f147ec42d130802c4696ecf3ab766483c4d1eac2d6a5258b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed364430d9e26ccdab387ffd8068de4039665dfa05b8422c39fbda5eef086c98"
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
