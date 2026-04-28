class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.78.16.tar.gz"
  sha256 "050b19ffa21c74ffcf338946e48db06c18d1cbdb51223dd9ccf82a7b563fc805"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86900d255b06e7f5d849753c68eced33cb171e9cad615aeb6ab978d9a35b05d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86900d255b06e7f5d849753c68eced33cb171e9cad615aeb6ab978d9a35b05d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86900d255b06e7f5d849753c68eced33cb171e9cad615aeb6ab978d9a35b05d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c7685cb5238400a5b4cc227bd42b4f6bd986686c3f89ab793d22655e052d8d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7db7af1a721ca25452cb8b0f81e96aa21ac9c8c62e710647e39098b68f29fae5"
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
