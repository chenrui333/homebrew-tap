class Md2pdf < Formula
  desc "CLI utility that generates PDF from Markdown"
  homepage "https://github.com/solworktech/mdtopdf"
  url "https://github.com/solworktech/mdtopdf/archive/refs/tags/v2.2.11.tar.gz"
  sha256 "a885aa945952326b86bd3e4425aa2119ea22e40110fdcb8c3afe95fa4ce6f428"
  license "MIT"
  head "https://github.com/solworktech/mdtopdf.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c687dd260fcc1ba255625064fa75e7c474b4b3851c0db13bb6eda60b85c4a196"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebaa14f693bd5ed1ed25218f9128841e887595b6fb5094f9f6e36624d4b21efb"
    sha256 cellar: :any_skip_relocation, ventura:       "9ce69538b959773625f8056e62faf49d604583bbdf73e9c0558e2e82d8913c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "689bfb13e622e41f24f3428b48b7f351872cb0df90fad95d906e3e18b5181cd9"
  end

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
