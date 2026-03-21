class Tennis < Formula
  desc "Print stylish CSV tables in your terminal"
  homepage "https://github.com/gurgeous/tennis"
  url "https://github.com/gurgeous/tennis/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "65a1d57d34442a97d1e470260eba43f7046c95ad47be217eed7bbb2595af873d"
  license "MIT"
  head "https://github.com/gurgeous/tennis.git", branch: "main"

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
