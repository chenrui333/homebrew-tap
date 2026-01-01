class Gobgp < Formula
  desc "CLI tool for GoBGP"
  homepage "https://osrg.github.io/gobgp/"
  url "https://github.com/osrg/gobgp/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "bec19105bd928200ea1ac2c9927571fbce5e11781c741da520b19b7b76f9a0d0"
  license "Apache-2.0"
  head "https://github.com/osrg/gobgp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e95bb13d24b9d359bd35fde0c218542b60308ef6d548934cbb474d3e3dae367f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc9a29ff53873291d3cebc30e9e7991064cb5228da2c4585de8d8373f2cb3133"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f790b4b6ad66ce09970de15b6d2293575bcdaeda56fc1de751ebf01718b99e3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edcb0db09b2a0cb3f996f773fcc1b2ed406c1239899d8a9a9da7acaa735ccef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "778d002320f106862953791c297736d2e4b7cc931fa4b05d602f1287e0bb7eb2"
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
