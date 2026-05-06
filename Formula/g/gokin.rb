class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.80.4.tar.gz"
  sha256 "6a04bc0ee4681a383388c87816f57056310d0e49b5a41ee16fed910fa3408401"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3e3e20ac9100cbe563f439e8b0c438b6287e6ed65b24fca996a53f8570402f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3e3e20ac9100cbe563f439e8b0c438b6287e6ed65b24fca996a53f8570402f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3e3e20ac9100cbe563f439e8b0c438b6287e6ed65b24fca996a53f8570402f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bec152927d1ca281423c6bda6f0c98f4355a0b0a0607c79be5f6299fe3afe738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2045dcfc095b051fb121a66dafc774766ab871e5e930ee8d860e13d3b987f036"
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
