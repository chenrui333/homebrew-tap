class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.4.10.tar.gz"
  sha256 "a315a38f0598554998e7b256d4ef997d158592532d43ca52328c8dc8e177d65f"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f9248213c60724c2f4df2def8af7680e9f34c0dbc6352bec328184cace53d08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fb2c55999f905f52b0f9f341469a5cc435f7a91d67fe697df4009c967250a1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f63dda76bb312fe0f268a3ce3e95cd75586e1508efc08f1540a638825cc8b5e5"
    sha256 cellar: :any,                 arm64_linux:   "fe6b3769c3e9dc85efffbf90ae80304cd1404dbba06d008c2c3c54d8c8efb9ed"
    sha256 cellar: :any,                 x86_64_linux:  "58d2a905eaa683e0605e3a6cf2abfec6c146e7ed9f37e50d6634ef98a913d105"
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
