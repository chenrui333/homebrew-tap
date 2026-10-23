class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.98.2.tar.gz"
  sha256 "bb6868fa9597c75eb6025d1629b81f803ec0868ab621fbb057a9dada4dae37b3"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18cb54099e36eeadd93bbd59939e20f133a7e3226521dd653c8a28126f63fa59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2269a950e1a54dceb787452accd7f2a1b01227a47adb0272d0d87fdb63540ca8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80fa81bbdaf32136a92545de78e85d433be9f0170d1346498cc0833386723022"
    sha256 cellar: :any,                 x86_64_linux:  "f4e31f4def3b5a31e8ec1e14b81f128eb5e9455069be5413f22c7d0eabf2039e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "No providers configured", output
  end
end
