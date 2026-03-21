class Weathr < Formula
  desc "Terminal weather app with ASCII animation"
  homepage "https://github.com/Veirt/weathr"
  url "https://github.com/Veirt/weathr/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "aa940326f41b23db192165f831567656ea50eb73c971519cbc83adc6d3a21908"
  license "GPL-3.0-or-later"
  head "https://github.com/Veirt/weathr.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"weathr", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/weathr --version")
    assert_match "_weathr()", shell_output("#{bin}/weathr --completions bash")
  end
end
