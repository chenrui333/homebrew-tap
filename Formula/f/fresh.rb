class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.17.tar.gz"
  sha256 "b26da263ec943ae24f42e1d9b4295416b56488e8eb9db8e8bbd5f46526a5868a"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed9890f6e7a17180507299ff9b4ce76aa15cc81911769f79a2c36b9bc8b8eda0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee8a2e0d06343a72acf8af9d3d75a4c024806d27fcc7363f8aae50237772ca1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04f94087aad9d791fd72b025fead9a75b1650b5735e166e63412702caac79fe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2973fd92a07507374673a66ded28b5cd4ca48c5d829f93ee29b58e933def065f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bfbb4dc98303fa1cdd59c6cc230c519abfd140479929f466632d417022f00fa"
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
