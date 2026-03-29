class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.20.tar.gz"
  sha256 "55ff033a3865e108a99a59eee6ea06428c4db3c8e19f1d9605e402c18015e6f5"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28082b281f11a6f49dc617db38a9e48f103d773000fdd7a2df03762dde8ddfee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae28049be9bb4db304b9582d490c51b63e1aacdec8ce879926275cf611f9e926"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "239d2163d4af7fc316915c30472f3d0e078750d4f625d3a5eb030286be11a847"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64975b57926f9e41a232f08f7c4243645f49260f1b8900e36591f578d66ca5a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b610df859fde704cb769bebb205b9b51ae207e5a0acaededc591353b4a3771e5"
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
