class Lazymake < Formula
  desc "Terminal UI for browsing and running Makefile targets"
  homepage "https://lazymake.vercel.app/"
  url "https://github.com/rshelekhov/lazymake/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "49dc29635990385fef22717d23c986a62803dc2afeeb428e0a1910711b169c37"
  license "MIT"
  head "https://github.com/rshelekhov/lazymake.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2961317d772740cb5880be209571336077671aec95dde6be4783624ccfd86917"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2961317d772740cb5880be209571336077671aec95dde6be4783624ccfd86917"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2961317d772740cb5880be209571336077671aec95dde6be4783624ccfd86917"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75c0703c9c79a026ac11dd2c62452341e37a4dc97a2dd76183d56c783dcae553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbc998d1ee856f1ed39f91fd84352d74e4894850ab3ba3c7b789025002e904e9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X github.com/rshelekhov/lazymake/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazymake"
    generate_completions_from_executable(bin/"lazymake", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match "bash completion V2", shell_output("#{bin}/lazymake completion bash")
    output = shell_output("#{bin}/lazymake __complete - 2>&1")
    assert_match "--file", output
    assert_match "ShellCompDirectiveNoFileComp", output
  end
end
