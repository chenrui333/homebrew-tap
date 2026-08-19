class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.90.0.tar.gz"
  sha256 "47a8b5ca440747b66f8aa8ea753ce1ef552e6917ad42237c4999bae928c0b17b"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a579803eabd529a5db6d4bd41dae8a442e316b381044e1950a601528941f397"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5b1a2bb50c4c8b712621dc84d42cd828e890e6c0568be5e4416cf988af5b840"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65ee6bb78b7fb1562cb36405775144faccc5b1cd19f08759ca92722f367994bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "698dbe176c078a3c0ffed247d6411bbc1acba84ef4bae61cb9c04044bf751059"
    sha256 cellar: :any,                 x86_64_linux:  "ee1a33c8a2a48400e4fc958cb08627120822e0cac56d84e422a25f5edef937d4"
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
