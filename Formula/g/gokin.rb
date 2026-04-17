class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.65.2.tar.gz"
  sha256 "ac25b149e784465625afb400d1fd2310f84519de03fe161129d8154cae60b26e"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7dbc11e73123ef6c3592fbf7713c4939c88c24f19a9ca6293c5d7daf911c871"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7dbc11e73123ef6c3592fbf7713c4939c88c24f19a9ca6293c5d7daf911c871"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7dbc11e73123ef6c3592fbf7713c4939c88c24f19a9ca6293c5d7daf911c871"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfd98547738770fcf30072cbeba9b0bedaa7d8293d9d2bc15bbb2f9c5d901e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87ae6442e1380ed4ac0001437c3bf5ee3542fa627e9f4b059b0b7d8283ec8cbb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
