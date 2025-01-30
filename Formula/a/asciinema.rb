class Asciinema < Formula
  desc "Terminal session recorder"
  homepage "https://asciinema.org/"
  url "https://github.com/asciinema/asciinema/archive/refs/tags/v3.0.0-rc.3.tar.gz"
  sha256 "3e7402589eac1a704951e3c48d769f5d007c52630f17ec895dfad6676e4ba6b9"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asciinema --version")

    output = shell_output("#{bin}/asciinema cat non_existing_file 2>&1", 1)
    assert_match "No such file or directory", output
  end
end
