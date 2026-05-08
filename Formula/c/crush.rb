class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.66.1.tar.gz"
  sha256 "afd4dfd58001f955ca429bdb8eea1329705d188d924a80c7a884bb9169efe089"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac2e2de193dfd284c1c5fab566b637a5db2cd6f0d95772af8bb9432f6ff4c519"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04b038bac08e8de274175248d81ade94963e768d27a2ca2b236d851b848a0ea7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f602abe140c4270cb37894577b05e6f2c509a200c16c65595d224d88c8fdc421"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1efc8e7c79c63003c7c5c011090cfb41131d43c8077f09624979b6ab76164076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70b55ed4e9545b51ae7e2853428af9d397be20a7646692ef71120f5a042d6f29"
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
