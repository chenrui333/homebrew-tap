# framework: clap
class Mdslw < Formula
  desc "Prepare your markdown for easy diff'ing"
  homepage "https://github.com/razziel89/mdslw"
  url "https://github.com/razziel89/mdslw/archive/refs/tags/0.16.1.tar.gz"
  sha256 "3b36540ddf8e9f5304d04700fdcac9ae5c741c8f0b4f7a1c37e15808d7a5ba10"
  license "GPL-3.0-or-later"
  head "https://github.com/razziel89/mdslw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c5cf18734179abbd2f8695e58ee363e1321ceb93ceac4e4641b9922b4187add"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba93ae3428879abb08e0c857fc715308def50e94d2bda7b64c5d829499d28a35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4401f70d47e18a96fa9ed3902697ff69f5197ce611dcf196752e90666e0a5f75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c509e0faf944ce3e0b5482232b748d9051f0485fe1eedcaad272d3730d3e0e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bbfce07770f2fcfedb00dd352ae4c67c51b39fcb9679163afb72493a6a69d02"
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
