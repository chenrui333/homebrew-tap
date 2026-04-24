class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.71.6.tar.gz"
  sha256 "1130bb232efa6fdaa95b4dd2cea179c31c58436fcfcb9d638da7ae7d8298ba00"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d13f658833dc1b8230728b6e729c2a9f35565500d56bce3dd0a9e7e21327b2b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d13f658833dc1b8230728b6e729c2a9f35565500d56bce3dd0a9e7e21327b2b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d13f658833dc1b8230728b6e729c2a9f35565500d56bce3dd0a9e7e21327b2b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faf530ff4b108c16c408e3f9e39a85bfaf11c3ca32889238c2ce7223e4b052db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c502604409fc75478afb8246eecf2f1973446a1063546450e866a9d422543c2"
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
