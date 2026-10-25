class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "394294af0c45db3977f28264e7bf5e15b437ddb141f4958f97e26eafcc87783f"
  license "MIT"
  head "https://github.com/dorcha-inc/orla.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dc7f75473626b6409b583d26b5afac0a55a6036acdb8e2675a22f0bd1255441"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7c1dd80b661f349562a914a9b55e3a0b30f7980f9455c62066a60abdeffea50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "191760e0406b7b8e6bf59739f34c855bfb6635fa9daa9a1009e5c582bac94706"
    sha256 cellar: :any,                 x86_64_linux:  "50ecbe65a8fe72041f09572a97a6654d33f1d0a0fceb20c537d28f753237f6fa"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/orla"

    generate_completions_from_executable(bin/"orla", shell_parameter_format: :cobra)
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    require "open3"

    output, status = Open3.capture2e(bin/"orla", "serve", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
