class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.103.1.tar.gz"
  sha256 "b2a8206ebbd981031fb7b4777ba147cbc075dbda75a9be3a5e0bf4d760197828"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d65a30516270b87084e3525d76d7a3765c340a5c6679f0915a1fcb877d6fd383"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00c8d5d415e7bcb1be9ee78773c6a85403537085eb8c88e08cb72b2d15df5915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0cdc4907ece4bf55a9e6f1ee12300516ecea53630df04883c1d0c8e2ce9f49a"
    sha256 cellar: :any,                 x86_64_linux:  "78af3c1c0c4ac4c5827565caf30437a835d3a19635f72b64e83e63a669a962f9"
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
