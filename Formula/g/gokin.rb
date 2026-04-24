class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.71.4.tar.gz"
  sha256 "a7460b593a0cef2b5b69aec564127192a1e6951a285c90a37aff833bad156e47"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16d5f53f22600d80b3731cb41e4bcc76797e080703484ff03983f3a950d2bec7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16d5f53f22600d80b3731cb41e4bcc76797e080703484ff03983f3a950d2bec7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16d5f53f22600d80b3731cb41e4bcc76797e080703484ff03983f3a950d2bec7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59be99cec276c5589bbd91ce58a2b0b62397a123b5eb9ee17c6af2954dd45c34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c11588c9f0912722c91c4128f0fb16fe41e5b3c0a89f05a0a796bea576f9754b"
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
