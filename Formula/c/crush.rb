class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.30.3.tar.gz"
  sha256 "32b2405db4784802534ae20f1bc6fb88a6446c85341edad72d32174e436321df"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "912aad61de88d2c686e973863496e3a257e8992b632c8eff8e0736cf8460cc04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "912aad61de88d2c686e973863496e3a257e8992b632c8eff8e0736cf8460cc04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "912aad61de88d2c686e973863496e3a257e8992b632c8eff8e0736cf8460cc04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7bd9928d4731039948e6769f033984ab207034d750e21f6a9799c0c1cc2000f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cf92edb543dfe4b049493f8be71a858d462620d9ffb20c0e99f388a62b7faaa"
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
