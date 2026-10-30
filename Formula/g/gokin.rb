class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.102.2.tar.gz"
  sha256 "540bddafe2b4dad237cbb6ddf15da40d9d45fc9631e39031f2cc3561a255eeda"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47b2fac7ed259a4f4496c3737d694e05efcd9ddca194857b0baaffe59b40796d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "878ecb83e128866afb807e5c1fe321f287593782c8fd168fc3d4fa04b25c12fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb030efc6a39b7624349a595ee37c534d5f4f48ecccb5547e2a36e4ac03c4a0e"
    sha256 cellar: :any,                 x86_64_linux:  "9d18f494ffca5a6f8e0c061443f66b322eb7d04e410c38bcedef2b82dd3fe792"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "API key not configured", shell_output("#{bin}/gokin doctor")
  end
end
