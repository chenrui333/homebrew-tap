class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.45.tar.gz"
  sha256 "cd18ee11db51f267729866bac5e738e8ebc3d8fd21e392963630379131d135d2"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81ca4d4656ed0f59a40372cd1d9cbaaf6a2b8a9e3994a9e32258ea9f3db57ca0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81ca4d4656ed0f59a40372cd1d9cbaaf6a2b8a9e3994a9e32258ea9f3db57ca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81ca4d4656ed0f59a40372cd1d9cbaaf6a2b8a9e3994a9e32258ea9f3db57ca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ae4d5585da6ae4a5b6e85d8dacac5efdc2b043c1ab20d65c73b25397cf8b38a"
    sha256 cellar: :any,                 x86_64_linux:  "e5bf5b2d64b17442e8bd0e5df7b411ec1b5acdd6faa2e16e63d47f578b6eb7eb"
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
