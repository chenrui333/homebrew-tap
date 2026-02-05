class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.39.3.tar.gz"
  sha256 "8514534797471ee2f797392be0b2805e63373c2f49209fd516cbfccd206150bf"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ff7fc41802abbb3255331add600275164047950aafeb1d58b47f565bcca04f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ff7fc41802abbb3255331add600275164047950aafeb1d58b47f565bcca04f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ff7fc41802abbb3255331add600275164047950aafeb1d58b47f565bcca04f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3bcbb234faf11f2d8e715cdb560a7a2480b723b4d15b7660bc293f452429a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cde6ce26b05b19e8ca1545ccc0e0d5559304bcf88b589b9fd939e37ff3e5f7d"
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
