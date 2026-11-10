class Jotter < Formula
  desc "Jupyter notebook TUI with Vim keys, inline plots and rendered LaTeX"
  homepage "https://samox73.github.io/jotter/"
  url "https://github.com/samox73/jotter/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "ebe6b550bb84d59079262ba0d2e3d6e8b644c3f0576d27005676a9a293d776f9"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/samox73/jotter.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06e3b1bfb7e27f4c3e4fe33330e4a904cda11db5abcb327631e36ca9c2722992"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d20b6ab2e8f8c5a748fb3b7c171e4d47248182aec7f8de16e0fcf6980b67f82a"
    sha256 cellar: :any,                 arm64_linux:   "65449acb93087dcff3fc2f6504c16b68dbe0cdc95544396464b9050269e0f744"
    sha256 cellar: :any,                 x86_64_linux:  "91935bb8950abe4aa83eeda46a89019071f73256481298b85326b407789fd05f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args

    system bin/"jotter", "--generate", "generated"
    man1.install "generated/man/jotter.1"
    bash_completion.install "generated/completions/jotter.bash"
    zsh_completion.install "generated/completions/_jotter"
    fish_completion.install "generated/completions/jotter.fish"
    (pkgshare/"completions").install "generated/completions/jotter.nu"
  end

  def caveats
    <<~EOS
      Running notebook code requires a Jupyter kernel, such as ipykernel,
      installed in your project's environment.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jotter --version")

    (testpath/"invalid.ipynb").write '{"metadata":{},"nbformat":4,"nbformat_minor":5}'
    output = shell_output("#{bin}/jotter #{testpath}/invalid.ipynb 2>&1", 1)
    assert_match "parsing #{testpath}/invalid.ipynb", output
    assert_match "missing field `cells`", output
  end
end
