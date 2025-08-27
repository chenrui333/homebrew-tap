class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "7cbd4223a054d68eb96dcd45b5eae3637d00a57194840290d4ab36e29ab44acf"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e87ec0aacfe6bf1067948c63dba00217dc2db196a440842427afe38e0b484357"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d81e6c6393c97b3c94766a73c286bcc3a63be3b14f26be837ee2482be3daa2d"
    sha256 cellar: :any_skip_relocation, ventura:       "1ade64991a8c9e7587a4b50a763863e8d3bc8e118d0ce64525295b3d81c25b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb47e0c767b30dfb1c5171d5679c087cd635304ebf4b954fca894b4963a7c1f4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "no providers configured", output
  end
end
