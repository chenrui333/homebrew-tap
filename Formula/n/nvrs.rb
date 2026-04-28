# framework: clap
class Nvrs < Formula
  desc "Fast new version checker for software releases"
  homepage "https://nvrs.adamperkowski.dev/"
  url "https://github.com/adamperkowski/nvrs/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "d306d520d76d84826e267c1baa58e497b9f14d7bd1d9b651f07e7f598dd7821d"
  license "MIT"
  head "https://github.com/adamperkowski/nvrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bec39e09115b9d296dfab0e53fed2dcd932b09c95e4114f2ec79836fdf5ec54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c3c11627fc55c8943d9a077456b7d1288097350051cf67559d57e2559b94340"
    sha256 cellar: :any_skip_relocation, ventura:       "b8df8dff79093f75510ab302cf69cb1b5b735047ee7dfe019596d7df065798b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e3316f33c8bf08102df01c6e3b2407dbbec2303e716b92d41aca6e8e4611330"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "cli", *std_cargo_args

    pkgshare.install "nvrs.toml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nvrs --version")

    cp pkgshare/"nvrs.toml", testpath

    (testpath/"n_keyfile.toml").write <<~EOS
      keys = ["dummy_value"]
    EOS

    output = shell_output("#{bin}/nvrs")
    assert_match "comlink NONE -> 0.1.1", output
  end
end
