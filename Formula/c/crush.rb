class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.30.3.tar.gz"
  sha256 "32b2405db4784802534ae20f1bc6fb88a6446c85341edad72d32174e436321df"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f80ef1da3e48a25ad2d068ebbd6a1e364775fb515d5f94dc7038139cefa4293c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f80ef1da3e48a25ad2d068ebbd6a1e364775fb515d5f94dc7038139cefa4293c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f80ef1da3e48a25ad2d068ebbd6a1e364775fb515d5f94dc7038139cefa4293c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6042b4003b5cd6c0f4ee71610732506f75d39ec8cccf15b1d1c0517241a5238d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "542ad31edc637c2434150ad2cf2aac1dfbee4664967f4b567345b46616a0ca82"
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
