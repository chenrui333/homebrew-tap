class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.84.6.tar.gz"
  sha256 "dc0e390710f02634b38c4e78f2ed3b2239caaabdaf5c1b5b20f8cf4e4b7190d9"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e584fe8b16954e88e19384ca6a9ac424cfb0e5a0f18b35e63f43492480462627"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e584fe8b16954e88e19384ca6a9ac424cfb0e5a0f18b35e63f43492480462627"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e584fe8b16954e88e19384ca6a9ac424cfb0e5a0f18b35e63f43492480462627"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4a2468874cf99a9e18aa220f77b2f347ef56273168a9a293e20c8c660a9fbf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d56ac1e62021275e64b989544133b912d59df1516613a1456bb69d5f8e19233"
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
