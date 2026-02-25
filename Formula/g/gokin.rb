class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "03ef3c41462373d6b5d095ac1b2969a7a9e503555eab1cf5c16a2db9c5f1aeff"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13e8eb70162aa4ff5d5b33a020e8f494f096866d1767c0a33dc6af1cfe71a0ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13e8eb70162aa4ff5d5b33a020e8f494f096866d1767c0a33dc6af1cfe71a0ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13e8eb70162aa4ff5d5b33a020e8f494f096866d1767c0a33dc6af1cfe71a0ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00c179feb8afd4d67286fc6f97cc9115535a5ee7ece39b6f6680844edd96a429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a03f1ee056ee3781e18156e4d4395270801b3c6373228750ec75fa6a74e594f"
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
