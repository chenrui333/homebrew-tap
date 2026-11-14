class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.18.4.tar.gz"
  sha256 "f7252262b87dac6e4a87c79860fbaca079af1256f040c2a1e83b86a0f6888ea5"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb961778323e5f53f749f861d0c0e0ac08a0c9940fc171be59709b5da4055b84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb961778323e5f53f749f861d0c0e0ac08a0c9940fc171be59709b5da4055b84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "524b1c794384d2f92e063241e6fbd57f68b92d3bf8393bd85e66e5a602dc55e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13064282e97defccdc924b4a5fd130cde508ad3548f2b15a5073efdc028560b5"
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
