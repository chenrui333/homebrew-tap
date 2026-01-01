class Gobgp < Formula
  desc "CLI tool for GoBGP"
  homepage "https://osrg.github.io/gobgp/"
  url "https://github.com/osrg/gobgp/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "bec19105bd928200ea1ac2c9927571fbce5e11781c741da520b19b7b76f9a0d0"
  license "Apache-2.0"
  head "https://github.com/osrg/gobgp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5ad1cf087392f3532bdf31b056f4a3a4eafd7c991800fcc8dff3f86b67d9fa3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dc583914ee0a7643af5d30e16fef8591b5259ecbee48b51c4efbb7791eb4a0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d295275825358d8c295d91eed35edccd0175986fa8730c74afc07cf13b63ca2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3baa037d963f1ac36a8b2dcb17f891532542fa8bb37a0f1da436c48e5ee308b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5c7261bd5535bd7bdae20f18cf7dd2e0210d90dab60a3371178bc9f46678be2"
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
