class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.80.13.tar.gz"
  sha256 "aadbd900be60a5bfaad6f852ccfcf2ec6134f1e6f872d57a53830e5eb851b54b"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e454e80f8b95eebdb21e37201a3df2d74d9c1da9769244351c4780380be8b9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e454e80f8b95eebdb21e37201a3df2d74d9c1da9769244351c4780380be8b9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e454e80f8b95eebdb21e37201a3df2d74d9c1da9769244351c4780380be8b9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fa5c3d1054e3840dea19b186790c0015e2359b79f39bfa2ff4ff208cb6d5b25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08faa6ab8e4c748a3e74c82163007ccf7d822380b2eb9600556f6f1b3d95a5b3"
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
