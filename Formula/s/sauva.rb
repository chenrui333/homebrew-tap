class Sauva < Formula
  desc "Terminal Unicode explorer"
  homepage "https://lusingander.github.io/sauva/"
  url "https://github.com/lusingander/sauva/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "163a74d4139c43603722678fda7036931e883ab7ef4e57dcb3d52ce90e05325f"
  license all_of: ["MIT", "Unicode-3.0"]
  head "https://github.com/lusingander/sauva.git", branch: "master"

  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Fontconfig is loaded by soname rather than linked on Linux.
    ENV.append "RUSTFLAGS", "-C link-arg=-Wl,-rpath,#{formula_opt_lib("fontconfig")}" if OS.linux?
    system "cargo", "install", *std_cargo_args
    doc.install "LICENSE", "UNICODE-LICENSE.txt", "THIRD_PARTY_NOTICES.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sauva --version")

    report = JSON.parse(shell_output("#{bin}/sauva -o json --text 'Á😀'"))
    assert_equal 3, report.dig("metrics", "code_points")
    assert_equal 2, report.dig("metrics", "graphemes")
    assert_equal "Á😀", report.dig("normalization", "nfc", "text")
    assert_equal "COMBINING ACUTE ACCENT", report.dig("code_points", 1, "properties", "name")
    assert_equal 230, report.dig("code_points", 1, "properties", "canonical_combining_class")
    assert_equal [0, 2], report.dig("graphemes", 0, "code_point_range")

    output = shell_output("#{bin}/sauva -o plain U+00BD")
    assert_match "VULGAR FRACTION ONE HALF", output
    assert_match "Numeric Value: 1/2", output

    output = shell_output("#{bin}/sauva -o json U+110000 2>&1", 2)
    assert_match "between U+0000 and U+10FFFF", output
  end
end
