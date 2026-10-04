class Gobgp < Formula
  desc "CLI tool for GoBGP"
  homepage "https://osrg.github.io/gobgp/"
  url "https://github.com/osrg/gobgp/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "27d8ef958100557344be98e459fa43a20d2a15b5ce943d2aed2772958a3bf397"
  license "Apache-2.0"
  head "https://github.com/osrg/gobgp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55366576ccf2850759012d9f40361efba4ba0986daff2f3ea2137f6d0ece8bb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b90be59f4575dc1d6418857164f094fb416ed55ad141650469412705ac95332e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ef983b29b0d115d93eaf2280cba4116acbf84ec889ef8d24833d3f0e49c4d36"
    sha256 cellar: :any,                 x86_64_linux:  "4d6d3658cc262780e76cdda75300900dea7302a4cdc0ea7dc731ae44d23ec930"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gobgp"

    # `context deadline exceeded` error when generating completions
    # generate_completions_from_executable(bin/"gobgp", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gobgp --version")
    assert_match(/connect: (?:connection refused|permission denied|operation not permitted)/i,
                 shell_output("#{bin}/gobgp neighbor 2>&1", 1))
  end
end
