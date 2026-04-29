class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "3f12fb1c1c23632f00c31fff2c73acde5d24cca28f1263e6b2393628a2300a59"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ea74ee38bc84cea4f08387e400fc0c275c053540b4fb68486992ec0b3e1b99c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b284444db5ed5c90461d11d893ffb37312f9b139eb90500eeb8679f4e0abd981"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9fcc88bd6befc827d2399c0852b7013e23abdf1b67f6672cb3597c71bc56da2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98664b190cfaf4a08767ef9c20147fd46880d580b9b7557479d40879974cbe4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09c4414d14106b3b22d54ef729343d080e4b63f8268fd231f5421cd2a2eeefa6"
  end

  depends_on "go" => :build

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
