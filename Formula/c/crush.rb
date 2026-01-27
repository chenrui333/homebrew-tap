class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "1ed72759b8326bc01bcd3ea57f67b7fd7cbfa0b598476f222e3dd5e2187935e8"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "512bd8653182bb12f3daf7199ddb74fb494e3e4d784195512165ede48d35272d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "060c298e0d35c315c848aef29361bff42b7974b3b9f8d3d43748a642fd6a588c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61e1375e741c8ba11ac8636aff57814dc18ad3dc242a194c7d066d3a89061654"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e3acf6a372bfed2b4918e764aa91847d537e58134f40892b6eb444b6b5547f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d3642d53ca995a7c0ace1921677667c0de8be5972ee6fc7e58eba347f5d8966"
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
