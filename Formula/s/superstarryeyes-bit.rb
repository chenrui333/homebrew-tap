class SuperstarryeyesBit < Formula
  desc "CLI/TUI logo designer with ANSI fonts, gradients, shadows, and exports"
  homepage "https://github.com/superstarryeyes/bit"
  url "https://github.com/superstarryeyes/bit/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "ab950b643de0bf8b6ebc64bf4fd68f40f4eaf8e33c5d320eeb3368d2657cff29"
  license "MIT"
  head "https://github.com/superstarryeyes/bit.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"bit"), "./cmd/bit"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"ansifonts-cli"), "./cmd/ansifonts"
  end

  test do
    assert_match "Error listing fonts", shell_output("#{bin}/ansifonts-cli -list 2>&1", 1)
  end
end
