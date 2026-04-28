# framework: clap
class Mdslw < Formula
  desc "Prepare your markdown for easy diff'ing"
  homepage "https://github.com/razziel89/mdslw"
  url "https://github.com/razziel89/mdslw/archive/refs/tags/0.15.2.tar.gz"
  sha256 "4bfd409054c20a403d9f8e7b4b3f11dabf421752507ed5da4381bc3515caa39f"
  license "GPL-3.0-or-later"
  head "https://github.com/razziel89/mdslw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90bdb497dbb85c1fd20e0da3d76acb1bfcaa9559583301f5ff86611b334f9cd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27b0e356b1925d512f9ff73ed4d5a1389b2ead0c345c5eacf2e45be700b94e56"
    sha256 cellar: :any_skip_relocation, ventura:       "b1e0216e051346d006f06fd121224e08db8212a1b9b582f963fd22b0afcef438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cd56ce932088a442fb8067b7d0e7c991ad19a04d0196bea9898bee6352375aa"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdslw --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Title

      This is a test markdown file.

      ```python
      print( "Hello, World!" )
      ```
    MARKDOWN

    system bin/"mdslw", "test.md"
    expected_content = <<~MARKDOWN
      # Title

      This is a test markdown file.

      ```python
      print( "Hello, World!" )
      ```
    MARKDOWN

    assert_equal expected_content, (testpath/"test.md").read
  end
end
