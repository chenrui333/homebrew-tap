class Tennis < Formula
  desc "Print stylish CSV tables in your terminal"
  homepage "https://github.com/gurgeous/tennis"
  url "https://github.com/gurgeous/tennis/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "f594102485056ac95f87d584cbd5e32e3449b65588bf650b8169b448cf2a8ce6"
  license "MIT"
  head "https://github.com/gurgeous/tennis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b27ab3bb59cddbcafbf7942c20b6bdd9dba32f7b3a2bdd9a39aeb41910e69b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3ced33ac6a1c3c5f227d67755e6098eae8ef34976e5ae554e93e3f3269dc5bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70327311ee7b04908c8a6b9ad35cba7abbfd8752de3a87064cf89b1edc889e7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5a5239cbe3ac4f39743d339597981841506e4db4c942e5218dabd1128fa4c8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d7071108802a2776986eea476c2aa6097617d87e708081f3c3dca2a2efba437"
  end

  depends_on "zig" => :build

  def install
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1"
    when :armv8 then "generic"
    else Hardware.oldest_cpu
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *std_zig_args, *args

    bash_completion.install "extra/tennis.bash" => "tennis"
    zsh_completion.install "extra/_tennis"
    man1.install "extra/tennis.1"
  end

  test do
    (testpath/"scores.csv").write <<~CSV
      name;score
      Alice;42
      Bob;7
    CSV

    output = shell_output("#{bin}/tennis --color off --delimiter ';' --title Scores #{testpath/"scores.csv"}")
    assert_match "Scores", output
    assert_match "Alice", output
    assert_match "42", output
  end
end
