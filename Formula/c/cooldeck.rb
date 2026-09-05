class Cooldeck < Formula
  desc "Keyboard-driven terminal dashboard for Coolify"
  homepage "https://github.com/Resetnak/cooldeck"
  url "https://github.com/Resetnak/cooldeck/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "3937c5949946fdb13af0aa2712794e8f52132f812898c1d0d29875ae2fc8422c"
  license "MIT"
  head "https://github.com/Resetnak/cooldeck.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d29853fe2ee294445b6931b4774edddbd7b6e61e7cc88dc36508d5295e714984"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d29853fe2ee294445b6931b4774edddbd7b6e61e7cc88dc36508d5295e714984"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d29853fe2ee294445b6931b4774edddbd7b6e61e7cc88dc36508d5295e714984"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27f03617683518610890204857ae888df64d420adc8b02e83611345d9f2e7ee0"
    sha256 cellar: :any,                 x86_64_linux:  "6cc485edf1098ba6c50639d63e6b219a8089621ba886ccc028df94c1abb1eaac"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/resetnak/cooldeck/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cooldeck"
    generate_completions_from_executable(bin/"cooldeck", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cooldeck version")
    output = shell_output("#{bin}/cooldeck --config #{testpath}/missing.toml config validate 2>&1", 1)
    assert_match "configuration file not found", output
  end
end
