class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.101.0.tar.gz"
  sha256 "691c622858bc79789d90c61eabc1c15532845e12de961296e292f0b92bba7fd9"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e7f562658ec6092e40634a9d4335fad5fac412fc4447aed3496e41734122285"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b22bb67dca104542d1abeb4ab58ee0b0aeb2f588c23e389275f753d7be31ddf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d85122c5c6023cd62a29496ec2719582fd998f23199c829183d71e2ab2b4298c"
    sha256 cellar: :any,                 x86_64_linux:  "e3226da970a0fec619d42c9da874b9a89c2ec632d3d4a18e80da7c9212fe344c"
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
