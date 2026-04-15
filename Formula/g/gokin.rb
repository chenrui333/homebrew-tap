class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "87df2ff91ddfce6c90c43726477dfc5cf0eea44b7fc90faf40f9c85a0c642059"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "083b75b3531aa45b362cff183afb1d76c6cad3cf405d7303ff27d4c7990fd3ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "083b75b3531aa45b362cff183afb1d76c6cad3cf405d7303ff27d4c7990fd3ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "083b75b3531aa45b362cff183afb1d76c6cad3cf405d7303ff27d4c7990fd3ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da799be34d5d3b28135eb37a2a086b67bd5c27843ef95cfabaf7db2c231ad9e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8abe907804593d19484a9643b0081bd4313e7f46fa439edda844bb84d4666165"
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
