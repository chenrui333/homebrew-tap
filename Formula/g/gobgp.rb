class Gobgp < Formula
  desc "CLI tool for GoBGP"
  homepage "https://osrg.github.io/gobgp/"
  url "https://github.com/osrg/gobgp/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "05df03495226913f7686103efca62a6866a848b57681cd4319a50089f1c3727b"
  license "Apache-2.0"
  head "https://github.com/osrg/gobgp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "805c0518e92140a1830dbd179f31c6bcfd931bee6ad692b85341111fa1beb1a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ba44bb3a810e0fd4fea3f9a08334021c04b64f3acb663fa95dfba3f3db1a9a0"
    sha256 cellar: :any_skip_relocation, ventura:       "cbb2e34491d70cd4d809ad8cd10bffe492abd0e2e5b9698a3e8961173be3fc22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46c6fc4bedf08ac641bb37fac7fead51117901023320fac0a8c10c8ff9c836c4"
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
