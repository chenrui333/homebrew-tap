class Tenderly < Formula
  desc "Debugging, monitoring & tracking smart contract execution"
  homepage "https://tenderly.co/"
  url "https://github.com/Tenderly/tenderly-cli/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "07cc5107a1f2aae7819982dac714ec3dd95e6d1b9b0e3a2c419eeeb81dab4985"
  license "GPL-3.0-only"
  head "https://github.com/Tenderly/tenderly-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c169e33ef98ef4607ea46bc6114957bf9f0e579151bb4be6e62daa5523445670"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c169e33ef98ef4607ea46bc6114957bf9f0e579151bb4be6e62daa5523445670"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c169e33ef98ef4607ea46bc6114957bf9f0e579151bb4be6e62daa5523445670"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4aaa6999c314603d7e406bfeaa51bc0a56ec453f8483e912a6a64246d106f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8519a86261ec7f522fc5877a2cb8cb3427202181cae75d74b42da172326d7ab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"tenderly", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tenderly version")

    output = shell_output("#{bin}/tenderly init 2>&1", 1)
    assert_match "configuration was not detected", output
  end
end
