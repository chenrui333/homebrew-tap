class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.25.tar.gz"
  sha256 "8524bb030a5549b790d56ce687b4af5e50131faac0b89975ad077b3875bb0296"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c4ffab9968429b3d3397d15521e7a13b4a9bcbe787b8d68bd30700803942276"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a33e484effb0a3e691341ae22c2240e50bbfb00e3dd3cc297d5510686c64ba6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a289bfedbeb4c3293b843674f5dcde3d9f45c34ea81136a01b0713803cefc076"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0bfeece734205a79d23b86060bee1e69e9195c3bf0b724165a5b0a129404205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "378952675cd3c002b279adc70dbcf2a29f5e3e0edb34def150e34503b9e6bcda"
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
