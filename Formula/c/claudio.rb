class Claudio < Formula
  desc "Hook-based audio plugin for Claude Code that plays contextual sounds"
  homepage "https://github.com/ctoth/claudio"
  url "https://github.com/ctoth/claudio/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "161e545fd5ca5336f89b923c65d32f638fdfb92bafee3623da6db2c0991abe52"
  head "https://github.com/ctoth/claudio.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "191857c019f76ee90595630794e60a30f828cdbc2f4e533143f6adc66bcd6611"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11e277e3f5fd6309739f515c8b2970ccdf0a4751875659255848473dc2e9ca70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48369beafcdb8cea2ce12753cce95359f60309ae5cd392e822eb527152ffc0cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb86dd703bb638bc2b7ec0446da5431b90d6d3509f43eeaf4ecc075ebf988059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f1d5b94898c31617fe8786c9f0644fad2251b109589c1ff3e5b2a500f9a07ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/claudio"

    generate_completions_from_executable(bin/"claudio", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claudio --version")
    output = shell_output("#{bin}/claudio analyze usage")
    assert_match "No sound usage data found for the specified criteria", output
  end
end
