class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.84.1.tar.gz"
  sha256 "802a5be8aecbf14125ae409b71c43527364d6bb66655201f8b4aff9a93ad443e"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d5402dd4c5502167be9378c793775c8e9ed14e7ba77f189e046506a6ca05f97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53601cf8c80ba8d96f4a3674a52a101fe3f501c7cf93c583f865477647c077c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e79c476430e2cc872ac20a6bb5616a828df848238b8a225b4f2b2f11b07bc694"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28e3168da067dc1f21c393bc5a722d06a63ea338a4c054a3fd0a7e3db77f1f2b"
    sha256 cellar: :any,                 x86_64_linux:  "bc3ea98b83346aaf2b4a09409067acb855791051051bfbf4b1a470ca78a653df"
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
