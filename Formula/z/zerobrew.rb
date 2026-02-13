class Zerobrew < Formula
  desc "Drop-in, faster, experimental Homebrew alternative"
  homepage "https://github.com/lucasgelfond/zerobrew"
  url "https://github.com/lucasgelfond/zerobrew/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "dbbddff4b22a264e993ab7b254e0eb87a958a559c8438671f4eac3fd5517868b"
  license "Apache-2.0"
  head "https://github.com/lucasgelfond/zerobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8816bcdc4c1d1a8ced16bed9c8a8a72e0be02e0bed4e537cc0f874a1ad47bb9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "256e829bf35991eec26accb1cb145ca7575fa5ddf5ef51c9454fd0d375ade862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76e1af8cc2aaf50d5ea2dad75456dec7f4bb8384d6c83dd588aad8f0e9329d36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "423440a1e267a57b588d60eac67078701eaff92c6f10cd7cbe493f2c846da9e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5218445ad50142bfeb927091f9136f73db3f67093ead30ecc9c3ea35d8415b8a"
  end

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
