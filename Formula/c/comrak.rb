class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "64dc51f2adbf3761548d9f3ab608de874db14d723e8ca6f9fbd88ebf3bff3046"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20280c0e53d1f43cf1bde0688c43c9316ce55329d0fb235a724f5873b78e7d45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df92daa5f6cc70e5afb9020242917dc70dba9b7a592f598b2d591f851102d3a4"
    sha256 cellar: :any_skip_relocation, ventura:       "a829a5b2b92ef7dd5a221b0a48d7a8ac8f6f96ca9adb2e090859817ba83b8242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "476e0dfab223413f933038370379b92cd5511724d1a1c682920ea7d64ef51033"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comrak --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello, World!

      This is a test of the **comrak** Markdown parser.
    MARKDOWN

    output = shell_output("#{bin}/comrak test.md")
    assert_match "<h1>Hello, World!</h1>", output
    assert_match "<p>This is a test of the <strong>comrak</strong> Markdown parser.</p>", output
  end
end
