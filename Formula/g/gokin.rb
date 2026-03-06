class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "870383a990cf6e2913d951a03229ef421f17bc69368b26aeae4f9aed6223bb50"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e66729413ba4f2e4276b7cc2002ba57b6179bdb440523f9e1a93c52862e8d59a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e66729413ba4f2e4276b7cc2002ba57b6179bdb440523f9e1a93c52862e8d59a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e66729413ba4f2e4276b7cc2002ba57b6179bdb440523f9e1a93c52862e8d59a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a56b1c6e8d90a2ee8296d3bfb63fe313e91d8b39314c73fbeb2115b4b46dcc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a97e3b8ec19f8c9c7a85039d741dc27fe59736cd5f5bfe6ccc2f7143400560d"
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
