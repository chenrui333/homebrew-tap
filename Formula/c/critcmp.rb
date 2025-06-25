class Critcmp < Formula
  desc "CLI to compare benchmarks run by Criterion"
  homepage "https://github.com/BurntSushi/critcmp"
  url "https://github.com/BurntSushi/critcmp/archive/refs/tags/0.1.8.tar.gz"
  sha256 "b89a2a0a1140dcf11aa66de670c62854212bfd57f674eea6da942b87b267ae9c"
  license any_of: ["Unlicense", "MIT"]
  head "https://github.com/BurntSushi/critcmp.git", branch: "master"

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/critcmp --version")

    # https://github.com/BurntSushi/critcmp?tab=readme-ov-file#usage
  end
end
