class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "1f417ab81c2af9f44aff53a4e7ca31053b4a93b572fb82bf49b0c30c804c6dcf"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c3f197bdc926c3f6a75a59687428311491f7b8b3d6220eba77b62d5252f8efb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "701455eeb93e2e256cdfdd4642fb876a137f1b27a62f6be9ec01123c4f5548c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7e3ee5bce4b26720419392d22a34debb458370c695e5f16e92bd74dc2f8915c"
    sha256 cellar: :any,                 arm64_linux:   "afdb4d7fa1cb0dcfe9e81041a35fc8cbdbeac937caf9147afd10a533e2f9e296"
    sha256 cellar: :any,                 x86_64_linux:  "517be24d80df74af7306f36c3fcb5dabeb733b2e41dacb10c5a935721cc23166"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm") if OS.linux?

    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")

    env = [
      "XDG_CONFIG_HOME=#{testpath}/.config",
      "XDG_DATA_HOME=#{testpath}/.local/share",
      "XDG_STATE_HOME=#{testpath}/.local/state",
      "XDG_CACHE_HOME=#{testpath}/.cache",
    ].join(" ")

    paths = shell_output("#{env} #{bin}/fresh --no-upgrade-check --cmd config paths")
    assert_match "Fresh directories:", paths
    assert_match testpath.to_s, paths

    sessions = shell_output("#{env} #{bin}/fresh --no-upgrade-check --cmd session list")
    assert_match "No running daemons.", sessions
  end
end
