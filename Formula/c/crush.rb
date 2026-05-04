class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.65.3.tar.gz"
  sha256 "b4f33c7a2ed2a16123553a1bf1a2ba0e00c33aba5ba11f710f22dfad3d552f1a"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdc9e3f85c479134348408c3d33584d8ca9224d6eaf941b532c870b5bac680bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e412fa1a4975def06b0d89fd5f29d263104ab4caeb60cd561192c25c395c54cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8072fc30db8c9dda320f7e324ac36b2c67838294b36e4d0f4f70f67d7b0c7dc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3886c8d3faeefe961f3b28c8eae36ae49f33f6c328c4a56a25f025ae8ba0982c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8af0b1404e42fde4f8a961bf3de29bfb0b14729ee5b6e27a99e52e69267b941e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "No providers configured", output
  end
end
