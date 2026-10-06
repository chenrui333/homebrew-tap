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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc19575c6936d09f8e1c8abb47f751ce695c5ed21d39d03e277402238d77851c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d143c41c530ee271bd8c496ccfbe2a2814e67b715c3f74a46a62322084a0c901"
    sha256 cellar: :any,                 arm64_linux:   "239ef0535699413f648b3797d8f7b25365baf53940b122a7ace81e7f539adf89"
    sha256 cellar: :any,                 x86_64_linux:  "5d04bc1657cf54897b8c98f78abaff04977c3e66a0802a563009604b094d8a28"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sheetui --version")

    # Opening a workbook starts the TUI, which needs a real terminal and hangs under `brew test`.
    assert_match "--timezone-name <TIMEZONE_NAME>", shell_output("#{bin}/sheetui --help")
    output = shell_output("#{bin}/sheetui 2>&1", 2)
    assert_match "the following required arguments were not provided", output
  end
end
