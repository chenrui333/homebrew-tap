class Gobgp < Formula
  desc "CLI tool for GoBGP"
  homepage "https://osrg.github.io/gobgp/"
  url "https://github.com/osrg/gobgp/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "e1c564a99481af8671c717bafcd59edfb4022c0dae73ea53320e2a9540c10702"
  license "Apache-2.0"
  head "https://github.com/osrg/gobgp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a941b1afb21d9a167f87da251b5e01b625cb3f43c37bb15d1b286cb7f3c08658"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aac4e8083420080bb8a3095ca20610c8f1b1485ef9edd07e00cd8fad10d2a01f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ae2cab5e2c1d51efbd120c09a6c449b57eee0e74520a4433c9be873450b027f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c61f2ff0d769de9cc5103b730b5f77a1f72d1a0655fa2f61f5736474d4071e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ca6ad70c8d0f792015bad81de975756345bbe88c220e01c4eb75322c9152324"
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
