class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "b556731a5018cc12a9cfca6de67bb52bc4d820e1103776d1bbf142a7752ae5c6"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7dcd2655dd46569f46324cd63ba67a0753fe0c3813fbdb0514eba5292b444e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f861b850ae7676f661081c586af0519889db78478b5850223783c48fa7be9ef3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03b2e48237e7cb489b1ba8cea2e5697d67589fee17e94e5e92c87ada4fd99548"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b461f240cff2493b9ca0cb613b1f37a58fddca63e40ba6d783198243f03e390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93d7e93acd67cbcff27017db5a3f75f3008d9ee37d0d31d52ff8b6d548c1f785"
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
