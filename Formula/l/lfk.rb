class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "ab877be46cf47709f4a8e3125f00d28b14c69738c2100c75c14530988a7eabcc"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5516d07014286eac2ba0a845aa022dfa9b630756205489c05a10ed1f4c5f0502"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5516d07014286eac2ba0a845aa022dfa9b630756205489c05a10ed1f4c5f0502"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5516d07014286eac2ba0a845aa022dfa9b630756205489c05a10ed1f4c5f0502"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1772290088bbc9e32adfe33ff09771aad860c27752afdd00979fd8a854610fa0"
    sha256 cellar: :any,                 x86_64_linux:  "9fceb0852e532b812eaf245dbeb4d5ca2df89760230c7307552edf607dc6e1cc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    assert_match "#compdef lfk", shell_output("#{bin}/lfk completion zsh")
  end
end
