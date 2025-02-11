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

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5af212a73fdaa67fbfbfd8106db7c8c6dece6bd7a4b04a3c3fab22bdc8f1e5f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0436c656973e5cb875bf21ee64c281d343e0c0c42222d293218a23a03893b331"
    sha256 cellar: :any_skip_relocation, ventura:       "ed2336de1b05022f0377cdf422b17a6a25743b42ff8044fdf829dee845143bdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59bf3dd661d329e266dfe194e3c5e0c615493e41e1aeb45e48ff91977f6ad245"
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
