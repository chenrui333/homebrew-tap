class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.63.tar.gz"
  sha256 "f1b8e7970617fb8d67ab3aa3fcd5ea645b413c33458e87a67485b3cf6c1d409e"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0829c850434b3acce250c7284666ed9f012bb1503d4a8dd7b5ba7929ced52667"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0829c850434b3acce250c7284666ed9f012bb1503d4a8dd7b5ba7929ced52667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0829c850434b3acce250c7284666ed9f012bb1503d4a8dd7b5ba7929ced52667"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4571c1a5b5efd2e809547cfebfbf16b69ce78d62fbd4379fecc655f9f6eaf60"
    sha256 cellar: :any,                 x86_64_linux:  "0ef26899042a672b14c83b6140c5a6c57c1b811c8fb4bbf49f26b0a2fd41a380"
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
