class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "483d918c6cbeca251977b033e58c9f67d9be3f1bc4ab4083437bea69c9fbdd3b"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "331f74816a5894bcb362058f4fb3582cb111aed89c0755f5c1f00b776f40e8fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa103cdf9f89283764dccd8a50582c86cec2bb93b1ee6d4611c9888f9dc1fafe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49728e5884e7f5342aa7b980a746ed7347374b92b411d899733998b862d66f0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0969f09cf78b3f31670662966472799109c965cb8558f8a907d0be036adebfd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e1a27c3d04c3bf0947a164ae4475d70726943029170e5b81290e795985f6e8e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib if OS.linux?

    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")

    env = [
      "HOME=#{testpath}",
      "XDG_CONFIG_HOME=#{testpath}/.config",
      "XDG_DATA_HOME=#{testpath}/.local/share",
      "XDG_STATE_HOME=#{testpath}/.local/state",
      "XDG_CACHE_HOME=#{testpath}/.cache",
    ].join(" ")

    paths = shell_output("#{env} #{bin}/fresh --no-upgrade-check --cmd config paths")
    assert_match "Fresh directories:", paths
    assert_match testpath.to_s, paths

    sessions = shell_output("#{env} #{bin}/fresh --no-upgrade-check --cmd session list")
    assert_match "No active sessions.", sessions
  end
end
