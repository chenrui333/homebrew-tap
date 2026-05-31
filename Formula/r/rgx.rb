class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "791dbfefbc471b308e185361946fb84cdbbf62fbec9726d5712da8bddad26fb8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58d17b35349be9d7209b282b69eeacca0f994fae4da4043c63e0a8aa148a7269"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a86ff4130607d01b1c9db39153cac807e97cf9ca4c98c11fd81ac9818c6b4907"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c64ae19a5ed36d86d8ce89f8589545aee7ab99aacf435cc52fc37636d34dcc2a"
    sha256 cellar: :any,                 arm64_linux:   "1b9a13c9c86bc8bef894a0dec54a5b610afad58633e21947c24cc1d62ab34f9d"
    sha256 cellar: :any,                 x86_64_linux:  "349191cbd1ebfb1abb391896d7048d9fce0ee73cf9a215bde218886b67c4644e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
    generate_completions_from_executable(bin/"rgx", "--completions")
  end

  test do
    assert_equal "42\n99\n", shell_output("#{bin}/rgx -p -t 'hello 42 world 99' '\\d+'")
    assert_equal "3\n", shell_output("#{bin}/rgx -p -c -t 'a1 b2 c3' '\\d+'")
  end
end
