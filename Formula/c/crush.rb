class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.71.0.tar.gz"
  sha256 "e2386ad30c92bce96582deda1acba9077bd635262d9511f7c7d74383a7c6eeeb"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dda017f037a2480b69033afbe6001fcc6043a8b97d1b86129bd4a52a85d8f1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "309f800fe9630129fbcde2f822433ed8f740dcf09adb1f3430c3e67d955bedd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca18ea9f6bdca72e362575f01549423acd721e32f422aaa7d80a1764abc08396"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ebe305476fe9e32118660135d7e7ec666f01db931bce8239afc4ee3b9cafa64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f87e9638d05bf4dda5d5f550b5b094eddd4fc05c4d1845d94de46980adaf27c0"
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
