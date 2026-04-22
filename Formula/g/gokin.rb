class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "db0e4545beebca0cab689dbdabf6504fdb231f935303043528f6c987761e7c06"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d2d74b964f9b3fcd58694912d483424adab865de2e4b595aab9f8978c0099a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d2d74b964f9b3fcd58694912d483424adab865de2e4b595aab9f8978c0099a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d2d74b964f9b3fcd58694912d483424adab865de2e4b595aab9f8978c0099a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9b99b29b63f43a09a89ab90ff45944881c7b733a5b10f9f6f78660a2d6c83fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceaab18dedb3228ee1e96cf7870d98e8c00f6017d0b4d65f527d1c4da17cd145"
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
