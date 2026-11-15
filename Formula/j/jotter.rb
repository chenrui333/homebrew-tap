class Jotter < Formula
  desc "Jupyter notebook TUI with Vim keys, inline plots and rendered LaTeX"
  homepage "https://samox73.github.io/jotter/"
  url "https://github.com/samox73/jotter/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "ebe6b550bb84d59079262ba0d2e3d6e8b644c3f0576d27005676a9a293d776f9"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/samox73/jotter.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6de31091164129cc70088b27d6dfe0174aaae168260c6ba75103113224286df8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a04720650d564ba643cdd9badf0f2cdc3476a73d3790122f62532de55c95aa6"
    sha256 cellar: :any,                 arm64_linux:   "837a759eae8f3921bab60baa62b9610f921931f8535f7e0d006962f245f72d1e"
    sha256 cellar: :any,                 x86_64_linux:  "66420c3f799d80d23bb458c6eb6bc1bf9bae0d1d8c129e7c6a60d71b412a835f"
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
