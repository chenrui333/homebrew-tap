class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.24.tar.gz"
  sha256 "8f9d55b275305a19f4a9e8c7fc90331491c443ed45fd4d7f59d05523b571bdb5"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "586153bb66cd2c2785196ada4661a35d70d342a8404b147a33cd3fe8264d2215"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94f64732737379bc84b5a4a2fb6590e6d7aff6cdbd71113d903b9555c9ff54bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08132be39d61d01c83ce717c1633526b5d9a159f7f91a2f9c7e002a720e37d5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4a0e31cb8995311f314f63a9664cd4b0aa57d13be1792180a67b1ae41f66ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46a222c30b074d7f2e1ad0d556f318f5081fae4927b410edb7ce0d9d889576c3"
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
