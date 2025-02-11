# framework: clap
# currently the project has mixed usage of sheetui and sheetsui, while repo name is sheetsui,
# the binary is named as sheetui, so using sheetui for formula name for now
class Sheetui < Formula
  desc "Console based spreadsheet inspired by sc-im and vim"
  homepage "https://github.com/zaphar/sheetsui"
  url "https://github.com/zaphar/sheetsui/archive/0a6807493c3e8fd9f4261135f0226d801a472d53.tar.gz"
  version "0.1.0"
  sha256 "5c8fe624eba2735c51d7077cc2b7fcb250f7f8001bb6b782600340631597d246"
  license "Apache-2.0"
  head "https://github.com/zaphar/sheetsui.git", branch: "main"

  livecheck do
    skip "no tagged releases"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sheetui --version")

    # No such device or address (os error 6)
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    touch testpath/"test.xlsx"
    output = shell_output("#{bin}/sheetui test.xlsx 2>&1", 1)
    assert_match "Zip Error: invalid Zip archive: Invalid zip header", output
  end
end
