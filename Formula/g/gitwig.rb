class Gitwig < Formula
  desc "Terminal interface for Git"
  homepage "https://github.com/tareqmy/gitwig"
  url "https://github.com/tareqmy/gitwig/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "15a03cc01f528bd2e915c170e1a1c0a7c2800fa5efbbe41769c3eba50cbbd163"
  license "MIT"
  head "https://github.com/tareqmy/gitwig.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "8ab6e7642587487e393aa738c8a8207300a22b56988ed8a60f9f73c1794613a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8675843d6fd34dc660b86ecea8a7f38696bda728896746383d1eda553380f33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4388b16da5ad0d75a09af70ea085317430f858fca98e3ec5f94825f36ea8d2ff"
    sha256 cellar: :any,                 arm64_linux:   "1ca8855847b86c2a786f936d1fa986577034bd9ebda3458386f4e8fd0a4784b7"
    sha256 cellar: :any,                 x86_64_linux:  "92bc265d50dfe9a62b0958b86e78b0cf9f02ae17f7354338f9c9d3ebea194d69"
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
