class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "3ab409970e18e692ed7a046bc0c27f4a68119858928e4b4b499e992dc7a0a118"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f520aadba3900ad07c53378f2313e904baf53b67228cf8dbaacb3dd7baf22da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f8dd2b28b62932372b6625f4e74cb89e2fac7cf77653812e82a32e9b2ae1010"
    sha256 cellar: :any,                 arm64_linux:   "8db61fe02d113f6ef7d1395e373abe6903a230d13b0665eedae1e03ee7b7e0de"
    sha256 cellar: :any,                 x86_64_linux:  "6400b2564b55a9ac976f33470bd81a2c22443f0e50032008ef463825e4b110b8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  on_linux do
    depends_on "llvm" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
