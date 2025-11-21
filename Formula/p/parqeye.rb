class Parqeye < Formula
  desc "Peek inside Parquet files right from your terminal"
  homepage "https://haloy.dev/"
  url "https://github.com/kaushiksrini/parqeye/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "67f896a9fe53a9f85022bdaf2042ae196feb784d2073df7d25eb37648d620139"
  license "MIT"
  head "https://github.com/kaushiksrini/parqeye.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dc06628e48d759834b016c6fb1494503f60e2e2238e56719196d58aa716c9f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06226f80f5fe16e13313908aaf4d82ccd36fe173ed0ce3820dc953b02dbf9219"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0026b7f3d343c47371f400fedb6ba21e5d9cb9eb669802792255f68cd3016d68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1346ea5667c291802b2df2ef1b876ae612385cc946470b2a960a781803e1dfab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3d011d1057430906e7791c44b7aa9b95da198d493d6b86f63279f55a3b9877e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parqeye --version")

    # Fails in Linux CI with `No such device or address` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.parquet").write <<~PARQUET
      PAR1
    PARQUET
    output = shell_output("#{bin}/parqeye #{testpath}/test.parquet 2>&1", 1)
    assert_match "EOF: Parquet file too small. Size is 5 but need 8", output
  end
end
