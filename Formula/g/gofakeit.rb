class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.13.0.tar.gz"
  sha256 "496ed599d4f79b50a8c52e8a73ab68ea6e010c25e83efa26cc0c4332b0c28791"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb93feaa393c3ee25c1a648af0d7ade79a0603f12e1a2c197ac99f0521220397"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb93feaa393c3ee25c1a648af0d7ade79a0603f12e1a2c197ac99f0521220397"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb93feaa393c3ee25c1a648af0d7ade79a0603f12e1a2c197ac99f0521220397"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3e4d4d530ad60e611da18c198de8369c37aa7bae2b67b253837956973b2db48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "966c37cbc2de44520f2e800051168c0382ab4024bddce773e3707e2c99ab28fb"
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
