class Md2pdf < Formula
  desc "CLI utility that generates PDF from Markdown"
  homepage "https://github.com/solworktech/mdtopdf"
  url "https://github.com/solworktech/mdtopdf/archive/refs/tags/v2.2.11.tar.gz"
  sha256 "a885aa945952326b86bd3e4425aa2119ea22e40110fdcb8c3afe95fa4ce6f428"
  license "MIT"
  head "https://github.com/solworktech/mdtopdf.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/md2pdf"
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
      This is a test markdown file.
    MARKDOWN

    system bin/"md2pdf", "-i", "test.md", "-o", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
