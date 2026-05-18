class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.82.5.tar.gz"
  sha256 "ab0410e20c07dcb6346a2835d2fa4a89940e2ca252ed6fca3cd22f96a92aa0df"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80729c773ac88be036f1a306212966acd6b58b449687d39d20cab9fdb8970b3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80729c773ac88be036f1a306212966acd6b58b449687d39d20cab9fdb8970b3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80729c773ac88be036f1a306212966acd6b58b449687d39d20cab9fdb8970b3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d1776cbb150d851c10fb905de7fb10b12a51c20c25ba9c0e68b6733f9351b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d783c24aaf3def4145a52d6a345e6d900e6478642b4bba8a0a1c7fc8be94cc3"
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
