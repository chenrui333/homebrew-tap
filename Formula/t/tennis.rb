class Tennis < Formula
  desc "Print stylish CSV tables in your terminal"
  homepage "https://github.com/gurgeous/tennis"
  url "https://github.com/gurgeous/tennis/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "65a1d57d34442a97d1e470260eba43f7046c95ad47be217eed7bbb2595af873d"
  license "MIT"
  head "https://github.com/gurgeous/tennis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c404adc8c48f5bbb220b0b505c16f2e577f4e79ad670d6101b52ead9cd0fe52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92636c62f7211a88634df5d9c18177c515ada0330705e66ee618b733ec422709"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51664cc308c0697e5568374f80f86cdb36c14391a42bb327c14f14e0107e5bb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c177a056ed6376f47a114a77f3bf272791f3ff89616b9e282ac0b23ed33094b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64cebead59d15c10406e7c2dd5f246d92fdd874160a7d999a8f367751aa8cd4c"
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
