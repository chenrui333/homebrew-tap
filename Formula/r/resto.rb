class Resto < Formula
  desc "Send pretty HTTP & API requests with TUI"
  homepage "https://github.com/abdfnx/resto"
  url "https://github.com/abdfnx/resto/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "6d5a1f773b8f21926af786123f436753c80bbea2e2970a96775c4996fd63760a"
  license "MIT"
  head "https://github.com/abdfnx/resto.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5731d2a898c2e46bfaf118f5837a3f05495f381d67f128930ccfd45bfc329403"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5731d2a898c2e46bfaf118f5837a3f05495f381d67f128930ccfd45bfc329403"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5731d2a898c2e46bfaf118f5837a3f05495f381d67f128930ccfd45bfc329403"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f546b81730abe804029282dddfb96f9507f794186b0827adae4c80d3dcdfa921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45c3a2c7d918ebc131c652aff7ed633d03baba3d8ff9638e3973e7527b120d8f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version} -X main.versionDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"resto", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resto version")
    output = shell_output("#{bin}/resto settings")
    assert_match "Update Resto settings like enable mouse or change editor theme", output
  end
end
