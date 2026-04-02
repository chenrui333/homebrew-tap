# framework: clap
class Mdslw < Formula
  desc "Prepare your markdown for easy diff'ing"
  homepage "https://github.com/razziel89/mdslw"
  url "https://github.com/razziel89/mdslw/archive/refs/tags/0.17.1.tar.gz"
  sha256 "4dadf34036002909b1c2e547facb88b37a3a3ac0cc102d9a924fcc0161db1637"
  license "GPL-3.0-or-later"
  head "https://github.com/razziel89/mdslw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78ac4b7941ef6aa80ebf9acee681903ecd5b887a42570e6e0efa882b882a9102"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1030256f7fb3db349d9da4ac1e0234f552981e6cfe967e7e852d3316cca3eabf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a0dd03fafeb3f5a12b5591a287c4c802795c994090454031bd97358fe3dc53b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3573755a914fd54de3f56b6996980209e8e1f8a55cffb4735761d6efaee0514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74b9046dedfa1d13bc65d9b3ce440014bc7ed71ec75643a3d649d155a77dbc44"
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
