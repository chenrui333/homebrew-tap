class Resto < Formula
  desc "Send pretty HTTP & API requests with TUI"
  homepage "https://github.com/abdfnx/resto"
  url "https://github.com/abdfnx/resto/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "6d5a1f773b8f21926af786123f436753c80bbea2e2970a96775c4996fd63760a"
  license "MIT"
  head "https://github.com/abdfnx/resto.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d94930dfd67384b2ff28a124e950edfc3a19f2bf25fb2ab053df2f1a3c8f35d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d94930dfd67384b2ff28a124e950edfc3a19f2bf25fb2ab053df2f1a3c8f35d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d94930dfd67384b2ff28a124e950edfc3a19f2bf25fb2ab053df2f1a3c8f35d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae1fb92c20100044a6e199bdb590ef607f41fb4fb2f15dfdca91677e66688bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "037029a2f037a524cd6caeba1e88a15f4a575bb6a1ffbe57697467d4c3fa0e12"
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
