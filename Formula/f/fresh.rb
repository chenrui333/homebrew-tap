class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "f8a3946662accf1989eabc4204333ff47e80214db3c2bf95fad45feae9c197f8"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cb2dad637f17619108404abb51fa97e87bc5543eaf84d8afe8632947d705757"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a13cf788bdfdd8357fc14a80801889dc3a1af49a4667a92f99c5b7cb22e1ed4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "355cc9cc2385177ce17acffef77b3e77962ae23990430e0410c23dbc0e7e5c68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caa6526f9a2bcf7563c3e79b47b737501f7fb12845e29c579cdcee10e3037103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adf75256b54a526349605c39297a056ae2e77cbe6d5fa1f362dedceb2aaf0f4d"
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
