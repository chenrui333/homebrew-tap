class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.105.tar.gz"
  sha256 "1826601aa11754c13f27b2272221b9659d969c6fe3adc5c64f2bea804dfee1ba"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36600c80048f57a8cf2aeee960c2ed47e63f0a7c4e57fcdf99171a526ddc9756"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36600c80048f57a8cf2aeee960c2ed47e63f0a7c4e57fcdf99171a526ddc9756"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36600c80048f57a8cf2aeee960c2ed47e63f0a7c4e57fcdf99171a526ddc9756"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09c401e59b4cde553cdc43aa2f96116526e5c94fec6e89e0260ccaae6add8df3"
    sha256 cellar: :any,                 x86_64_linux:  "36a713721caff65b586578e2df40b76a79205753f374975c57c5862c7e2dad90"
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
