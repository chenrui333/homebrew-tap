class Gobgp < Formula
  desc "CLI tool for GoBGP"
  homepage "https://osrg.github.io/gobgp/"
  url "https://github.com/osrg/gobgp/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "a23224bee8062376b7bed7c6da9cf72ff518609f9e092eb1b876b976c12904c6"
  license "Apache-2.0"
  head "https://github.com/osrg/gobgp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f0fb0f2f5cd8c20cbcf5d07ee7557692aedad7215e9df275a16c428ea523831"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8d1f5326ba8ad149503a7ab99cce0624f76f885e0bc8db6251f8ba56fa81a93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "444b3bd5917890427b446329e9bc0b8b4be9596850a0a5bc845994a00b945167"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95fa61a47b95e9da1a125f645b240e1a2092103538e4cd28b0f94ffaf3e933a9"
    sha256 cellar: :any,                 x86_64_linux:  "7864ae9b7aa1dbfdd972e72fe98c1058f3823a2b10dadbe622cb908cde3d6da0"
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
