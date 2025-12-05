class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "bd1e63bdbb1f6923002158ea01f785f4ff277e2d2e22b82f79cd9e12bb3fa662"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ee12b5dafc9d180e346fc56edab37b6b12bc4974f04ec688f22fecffebb5177"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dae37f6759bf35660f324a97f6b32deae3e7fa83b4917c960ebc9cb54339acc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3f968b6d48122cf153809e07584d8497424f09d71517b6b76c41e7bf8f1fc9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62d50c77e158261c62478615a729f4733d092abbf4041c1256ce75f3c9ad2022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29a73d8c52769b3b8f71159bf27a6f169b2eca8dd53ed89a33fbc905c601df3b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end
