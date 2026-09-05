class Regexplain < Formula
  desc "Explain and visualize regular expressions"
  homepage "https://github.com/kapilpokhrel/regexplain"
  url "https://github.com/kapilpokhrel/regexplain/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "946bb593c24a9b1116ced80018657239377553882bb74fde96953244b9831194"
  license "MIT"
  head "https://github.com/kapilpokhrel/regexplain.git", branch: "main"

  depends_on "rust" => :build

  def install
    # The release tag is 1.0.0, but Cargo.toml still declares 0.1.0.
    inreplace "src/main.rs", "author, version, about", "author, version = \"#{version}\", about"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/regexplain --version")
    output = shell_output("#{bin}/regexplain --no-tui --pattern '[0-9]+' --text-to-match abc123")
    assert_match "matches:", output
    assert_match "123", output
  end
end
