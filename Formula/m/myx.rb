class Myx < Formula
  desc "Terminal Spotify player"
  homepage "https://github.com/HaseebKhalid1507/Myx"
  url "https://github.com/HaseebKhalid1507/Myx/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "50a689fa07d9a4bea909e265351a5acfe7cbd7183d055543d4c1ee7c4cb220f4"
  license "MIT"
  head "https://github.com/HaseebKhalid1507/Myx.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

  end

  test do
    # TODO: Upstream does not expose a version command; add a version assertion when available.
    output = shell_output("#{bin}/myx theme get --format invalid 2>&1", 2)
    assert_match 'unknown format "invalid"', output
    assert_match "expected sh, css, hex or json", output
  end
end
