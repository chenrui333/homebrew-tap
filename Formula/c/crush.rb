class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.98.0.tar.gz"
  sha256 "73797f27d29332453abc3f4035f9279fdc38555cbb89defeb038677014663cfe"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d0917e43ab5d698c92e778bf18934ceae509222231fa2f152c3c49b2077cbe6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d936de2e6b9ac97ecb080e4c6b4d02998157e0dcb88fca9ce851fdee0ab0d1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1022fff776c5a0fecf72eba1bd5933160c48c8c4ee28dd2fb5ac901d359d4594"
    sha256 cellar: :any,                 x86_64_linux:  "a958158f391399a754fdc20c82927467c8d6e362a14a5ae71ebbfd2bee54f509"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
