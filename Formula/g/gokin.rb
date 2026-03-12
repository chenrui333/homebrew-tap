class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.54.2.tar.gz"
  sha256 "d79e4abfd2beb3e3970ed5858307035187a3cd0b574b360c9d51cfc4a8622240"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f1ecddab37f7db7f4256477810df22839cf5cb424ca7b202534cf099f3f134b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f1ecddab37f7db7f4256477810df22839cf5cb424ca7b202534cf099f3f134b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f1ecddab37f7db7f4256477810df22839cf5cb424ca7b202534cf099f3f134b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "677eabe26c4353102cc2d7cc88a192bd41e4ec504b0e9ca02930f0cc6c0862d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b0fa161f1e4f2111366c64aafcf96f1bae1f9633c008246301a4122afb17382"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
