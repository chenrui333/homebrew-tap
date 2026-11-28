class Gitwig < Formula
  desc "Terminal interface for Git"
  homepage "https://github.com/tareqmy/gitwig"
  url "https://github.com/tareqmy/gitwig/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "15a03cc01f528bd2e915c170e1a1c0a7c2800fa5efbbe41769c3eba50cbbd163"
  license "MIT"
  head "https://github.com/tareqmy/gitwig.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "77f22470b2466e57b0d4c99f9c99b65faf699ead6bb656efd51d58b16d807210"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17a98966f86c03216440dbec2b62301c332d847f20b24a79db00802c0d8fe3fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cb5f978be16ecd6d5999b13f9ed43947aa5113e420c268ac10ac6aafafe53c9"
    sha256 cellar: :any,                 arm64_linux:   "68c240575d3b5149e6225b85fda3868349c3831c0233556aa15b59ef0e8b2094"
    sha256 cellar: :any,                 x86_64_linux:  "21bb0145685aea7b7dc774adf90d3e50bf3ea13bb23f80f0a3d71393edc7f1c6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitwig --version")
    assert_match version.to_s, shell_output("#{bin}/gtg --version")
    with_env(PATH: testpath.to_s) do
      output = shell_output("#{bin}/gitwig 2>&1", 1)
      assert_match "'git' command-line tool not found on PATH", output
    end
  end
end
