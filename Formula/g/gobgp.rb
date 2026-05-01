class Gobgp < Formula
  desc "CLI tool for GoBGP"
  homepage "https://osrg.github.io/gobgp/"
  url "https://github.com/osrg/gobgp/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "d4d0f0f4553989b85f7bfd01cf460e34822b733478ecaaabb452a5893ee9d2cd"
  license "Apache-2.0"
  head "https://github.com/osrg/gobgp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "015ff5a1002de834f69251c8396257c333af5b42927caa8965f6a5af020dc43f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83fed719c2744231532d79de58c8f74ad6eeded5327d37ee428fdf32e97afd56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e423c22789615230e3a4757831ee8a2a0c151e036880e64641cd8d279a6d5e22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb9738685cbbed4764f82a19b7150fc6d1801e6fce977453748c64cec1115a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3d21701cae234c0515865a1d9400bb197afa57c55cad78a3ab5cfd2afdeaf05"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gobgp"

    # `context deadline exceeded` error when generating completions
    # generate_completions_from_executable(bin/"gobgp", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gobgp --version")
    assert_match "connect: connection refused", shell_output("#{bin}/gobgp neighbor 2>&1", 1)
  end
end
