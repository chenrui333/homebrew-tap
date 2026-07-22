class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.109.tar.gz"
  sha256 "121c669306b8aee73903e875aefdb174885cad2d5e0c4048151bef4358ded0da"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37b06aad412e11bd802c55834bfb669b35147f72ed93b170a69d56c5521787f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37b06aad412e11bd802c55834bfb669b35147f72ed93b170a69d56c5521787f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37b06aad412e11bd802c55834bfb669b35147f72ed93b170a69d56c5521787f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c92fc2f5c8f3a2bcbac437301f152cb298e8ce0a5ce9f7f2f887e3d64ee0b71"
    sha256 cellar: :any,                 x86_64_linux:  "ce3f12c03808696be39b5bc916276d0314cbf9aca123145e744554f0d8c926e8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
