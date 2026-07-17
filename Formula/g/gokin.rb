class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.95.tar.gz"
  sha256 "dfb01f0e6890e4bf7767c3865815dc7fb54874a2201bc72cb2d0889df5fc9dea"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d04764ba7afb1ba3a5565299a387600ccd6ea401adbc3b9447d627e33a010204"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d04764ba7afb1ba3a5565299a387600ccd6ea401adbc3b9447d627e33a010204"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d04764ba7afb1ba3a5565299a387600ccd6ea401adbc3b9447d627e33a010204"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d5971598f8a7fb899d4cb0cc3b48a21f3e5e042fc8de5cd6bc35b712077e88a"
    sha256 cellar: :any,                 x86_64_linux:  "aa4e2abb7270e0bec3fe6a7807194e0350a8a62d1a4cebcddccf7fe1f23eea00"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
