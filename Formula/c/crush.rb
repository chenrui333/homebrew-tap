class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.87.0.tar.gz"
  sha256 "6679e4fcecc47bbc5173f3bfffa549776674c915a531f0559478bb0c806a21d5"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fea4313a41c1045abff01bb1bec0613780b063a9a29d478a0723b174c6c41f2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbf93fb9df53cd0f4b3e5604adf50816c2b909e13974e859af0eb546b6b3c5f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cadca8d0e5b4756b13f2d6b20c553bee971eed2343b2eec249bbc2e9b72ded3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54732a20130fdc36bcb2f25506d1297c6d82cf341684a01fc6ea17622d47559b"
    sha256 cellar: :any,                 x86_64_linux:  "1caa57e303f2e24a18e7839582e320a4ed0427c0302aa32a9229b2006a1c0ed1"
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
