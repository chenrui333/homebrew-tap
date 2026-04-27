class Tennis < Formula
  desc "Print stylish CSV tables in your terminal"
  homepage "https://github.com/gurgeous/tennis"
  url "https://github.com/gurgeous/tennis/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "31a23740c51008d870cc90b6236473ed009b0957f17c9db62ed9f04aebb7f9b4"
  license "MIT"
  head "https://github.com/gurgeous/tennis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d8da977cf37910d38ae3713681c10524fb94a090fdb37ac51fb3d2c0bb89a7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3c1eb0b6fe1b8e7abdd836ed82e19df088460b97a3c76d96fc70ddb20f40c9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "446cac55c62354ff5a2e46592399ab04205b7b04ffed614be02810db0d78bbc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f72317e8b1fc70088822044591036bbb899921581b7b09a50c0b6fe8eb12ea6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f4c5f7328b7b587f242bd3c9cc6fda9c00c2bc31e7e1b15017d66cd8824f310"
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
