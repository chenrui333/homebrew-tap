class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.81.3.tar.gz"
  sha256 "c247cc405617500edc046610966f1749f06f83559a2618e70ca7729eaea17d9b"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14b6154d679d84cf737e7aec873e90d5026cd4f4085942c9249b7c4418f8b206"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14b6154d679d84cf737e7aec873e90d5026cd4f4085942c9249b7c4418f8b206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14b6154d679d84cf737e7aec873e90d5026cd4f4085942c9249b7c4418f8b206"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3c72d1e1e02432a2dc7bceb17140effa7907fab9c79a988671019e0b6c65f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7109c382fc99c8011a2951dd319d1f54e77e66b5042a8d8b0cb8dc8b16e6e782"
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
