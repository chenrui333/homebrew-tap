class Critcmp < Formula
  desc "CLI to compare benchmarks run by Criterion"
  homepage "https://github.com/BurntSushi/critcmp"
  url "https://github.com/BurntSushi/critcmp/archive/refs/tags/0.1.8.tar.gz"
  sha256 "b89a2a0a1140dcf11aa66de670c62854212bfd57f674eea6da942b87b267ae9c"
  license any_of: ["Unlicense", "MIT"]
  head "https://github.com/BurntSushi/critcmp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c44476df526e3d81bdb9861eaa34ef46334ade6c0e8588e4d7079c2dd0a25fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43f34408ad5da29259e0010ff5e52a3231ffa9e5911ab59ad83ad98e1754e275"
    sha256 cellar: :any_skip_relocation, ventura:       "734c260f105c3d442ea79fcf85642421697c368e35de34daa2d6e2389c91953a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5ec9cfb442a982487a8bf58b560e411e4518a836d440ac2d16f3f29db02f481"
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/critcmp --version")

    # https://github.com/BurntSushi/critcmp?tab=readme-ov-file#usage
  end
end
