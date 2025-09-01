class Frep < Formula
  desc "Fast find-and-replace CLI"
  homepage "https://github.com/thomasschafer/frep"
  url "https://github.com/thomasschafer/frep/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "45753c1e0d24fa206dff615f27993eaa796f0d9160d44ae7477916a58c6df6b1"
  license "MIT"
  head "https://github.com/thomasschafer/frep.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a13802d5a612ed98a3f7133824903c48143df208f4896207987fb1f71bc24219"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbc92baecf72308105cecf9fe83da80dadb34a69a3bc72df16fc00a0bf2371f7"
    sha256 cellar: :any_skip_relocation, ventura:       "4d704e9cacb5cdc44b6abdaec85555e9c0e876ad43f08202cacbffc4be5edf57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7cfae62ad874a557ef3da25d228f0aba97d695b9c6f369a3760dcf615837531"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "frep")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frep --version")

    # skip test on Linux due to
    # `Error: frep does not support stdin input. Usage: frep <search> <replace>`
    return if OS.linux?

    (testpath/"input.txt").write "Hi, World!"
    system bin/"frep", "-d", testpath, "Hi", "Hello"
    assert_equal "Hello, World!", (testpath/"input.txt").read
  end
end
