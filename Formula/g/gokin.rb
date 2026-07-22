class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.109.tar.gz"
  sha256 "121c669306b8aee73903e875aefdb174885cad2d5e0c4048151bef4358ded0da"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e84472e50fd2e94e554b555ae38e2f229e6e84c621f8fdbf58887146419a90f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e84472e50fd2e94e554b555ae38e2f229e6e84c621f8fdbf58887146419a90f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e84472e50fd2e94e554b555ae38e2f229e6e84c621f8fdbf58887146419a90f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b74f9b5ff61082340a906b077078d91f0192a630576d6a2bc028711fc2e2af48"
    sha256 cellar: :any,                 x86_64_linux:  "24a3ef96bffbc9af5cc35d54336690573a22ca6408e3c342695f157f93302a38"
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
