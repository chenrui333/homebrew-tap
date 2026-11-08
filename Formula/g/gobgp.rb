class Gobgp < Formula
  desc "CLI tool for GoBGP"
  homepage "https://osrg.github.io/gobgp/"
  url "https://github.com/osrg/gobgp/archive/refs/tags/v4.11.0.tar.gz"
  sha256 "6b8358988a1261938fbf59c317f648251f2e0b8d0229015c83db5019e451c474"
  license "Apache-2.0"
  head "https://github.com/osrg/gobgp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c748e53d5c6d9a18822abeca4eed98a14b1fea428b4d0b3d424d0ff7cc777bf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4440ad403e46ea38297f34e24f86a2bc600c7750199d12cbd9d292d775e548ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a87c87756263db34b1a3a8f873c0477a3d219965d7ebc1e370e97a05914cc50"
    sha256 cellar: :any,                 x86_64_linux:  "2a16ad41ed8fb6db9c04e97ef40b512625b63d7ff61cce447608740fe10d4eb0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/gobgp"

    # `context deadline exceeded` error when generating completions
    # generate_completions_from_executable(bin/"gobgp", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gobgp --version")
    assert_match(/connect: (?:connection refused|permission denied|operation not permitted)/i,
                 shell_output("#{bin}/gobgp neighbor 2>&1", 1))
  end
end
