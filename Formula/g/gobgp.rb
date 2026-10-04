class Gobgp < Formula
  desc "CLI tool for GoBGP"
  homepage "https://osrg.github.io/gobgp/"
  url "https://github.com/osrg/gobgp/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "27d8ef958100557344be98e459fa43a20d2a15b5ce943d2aed2772958a3bf397"
  license "Apache-2.0"
  head "https://github.com/osrg/gobgp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca86bd8fa7b18d4dc466efc12ae2eaf7e2c2ff48830b58943009849d52b56bf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2758fd529942a518f2a70ff57d4e63a018528571f1bf8bc0708afd54613e8ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d1fb417e8ce7b62f10cd9eae4f581618e2ca9d7e763378ebffc94487bf79bd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0b78381c2153195c55391814b2a8c67d9c318897bb842dc4cfc78d02d76133a"
    sha256 cellar: :any,                 x86_64_linux:  "a97fa52de6fdd16f471149aa82a32242668d2e7771ed003d189ede4209f34ac2"
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
