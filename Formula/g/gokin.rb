class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.52.tar.gz"
  sha256 "5cdbd93800f7759dba16dbcb4052dfbeff2f4eacc2e04b44a8a83a18f71edf28"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e0c07c4d3a39d34c494954c04886c27d47f9cd899d7623d299e99ecbcacacd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e0c07c4d3a39d34c494954c04886c27d47f9cd899d7623d299e99ecbcacacd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e0c07c4d3a39d34c494954c04886c27d47f9cd899d7623d299e99ecbcacacd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b4124fd49893a824ad4cc0a8e6a187be65b4d6bd8d95a940c0188260874e6e9"
    sha256 cellar: :any,                 x86_64_linux:  "f22c2d50b09abefeee0bce10a9f66e90873a76f4518dce563f8ba14105f7f995"
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
