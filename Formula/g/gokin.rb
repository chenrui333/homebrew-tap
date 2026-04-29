class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.78.25.tar.gz"
  sha256 "b8516333a06d4cc026c7f68d46708388504783faf7a9c3ed59e5543a3abf86b7"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b80f5cb831fa772aae38b41594def34a3a7e53615c760c2d7bcbbcd2a5033856"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b80f5cb831fa772aae38b41594def34a3a7e53615c760c2d7bcbbcd2a5033856"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b80f5cb831fa772aae38b41594def34a3a7e53615c760c2d7bcbbcd2a5033856"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82bb2528456ebf781a2622a94fda4797ec0620c9977201a15d011b935688d8a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d494d18fe846a32b05aa05874fa61b260d0cba15f631ca937b20f5eec88e6722"
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
