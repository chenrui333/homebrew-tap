class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.140.tar.gz"
  sha256 "4274a7ef5928dd4fdbb13de73ee35ecd7539fde047f71269bfcf32009dc5c204"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5866af64d88826134366af26d60d7dcc6c6fa62b328b06747e4d63fd51f16a0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64b44537428317a95a10def261e43c6a53b984772b1f5b8545e950c099a19a15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "709cb890f9fd7735ed3b21b82f8dfcaa644e1b1062a17e71160bf9d36db7431e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fedf5b2643f041bb19d957f5f3125742b17241183266813cab9bd69f36d935b9"
    sha256 cellar: :any,                 x86_64_linux:  "735e1fa843ea048e0557fa9b89456229d8879b9acd72ce468fa417f58819dbe2"
  end

  depends_on "go" => :build

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
