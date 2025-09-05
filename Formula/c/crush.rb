class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "4d1eb828c53d999da51718c328990d86d5e9e9449e415dff315696a2b8ef1c5f"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d990f3383d422bf4b1e058945d8a7cdf12d70a3d0c88f5cac8fababe3e9adf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c1cfa1a085ddf5ab56c96533622452140b3414f10ea4da6d38ebf96152adf37"
    sha256 cellar: :any_skip_relocation, ventura:       "33611da60c69d2e8d6e12f334e92861d82d48c72d56b80f5fd262e3cb28dd47e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5931b547f1de166820099f5ba1949a87ebe4336178b2855f2d53eecd418885c8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "no providers configured", output
  end
end
