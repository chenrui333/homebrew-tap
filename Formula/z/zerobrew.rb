class Zerobrew < Formula
  desc "Drop-in, faster, experimental Homebrew alternative"
  homepage "https://github.com/lucasgelfond/zerobrew"
  url "https://github.com/lucasgelfond/zerobrew/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "dbbddff4b22a264e993ab7b254e0eb87a958a559c8438671f4eac3fd5517868b"
  license "Apache-2.0"
  head "https://github.com/lucasgelfond/zerobrew.git", branch: "main"

  depends_on "rust" => :build

  def install
    # upstream has already bumped to use 0.1.2, https://github.com/lucasgelfond/zerobrew/blob/main/zb_cli/Cargo.toml#L3
    inreplace "zb_cli/Cargo.toml", 'version = "0.1.0"', "version = \"#{version}\""
    system "cargo", "install", *std_cargo_args(path: "zb_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zb --version")

    ENV["HOME"] = testpath
    output = shell_output("#{bin}/zb --root #{testpath}/root --prefix #{testpath}/prefix init 2>&1")
    assert_match "Initialization complete!", output
    assert_path_exists testpath/"prefix/Cellar"
  end
end
