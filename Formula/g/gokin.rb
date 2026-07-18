class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.105.tar.gz"
  sha256 "1826601aa11754c13f27b2272221b9659d969c6fe3adc5c64f2bea804dfee1ba"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bc93a1fada3e926019a455bc6a1a9d06ece07cbf3a7562a4e5d40365c15d8ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bc93a1fada3e926019a455bc6a1a9d06ece07cbf3a7562a4e5d40365c15d8ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bc93a1fada3e926019a455bc6a1a9d06ece07cbf3a7562a4e5d40365c15d8ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fd23ef97300f88fe7082b50bb71dbf5a562bb62f35dfc53547f6a8262422df7"
    sha256 cellar: :any,                 x86_64_linux:  "9299d78a354aac859de5a6588ae529d5c0bc2dba1629841bf4da324b4acd0f19"
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
