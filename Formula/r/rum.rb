class Rum < Formula
  desc "TUI to list, search and run package.json scripts"
  homepage "https://github.com/thekarel/rum"
  url "https://github.com/thekarel/rum/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "458053bb4859f17bed8ec8be1c15179e1a84b45ae3441a50530bb207699942ad"
  license "MIT"
  head "https://github.com/thekarel/rum.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fc4ed28066a27ffd78a5bf3b79bc1484f5e1bcfba97cf62c717300ade0bb4cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fc4ed28066a27ffd78a5bf3b79bc1484f5e1bcfba97cf62c717300ade0bb4cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fc4ed28066a27ffd78a5bf3b79bc1484f5e1bcfba97cf62c717300ade0bb4cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98dad7e2bfd2ba789fe59c914bea149f4bbaa2d8eaf516caed0b317f49849fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "306c6ed0a20a845a3ff4bf3bb64a947ea77099640b2bb092d7e2046938f3f59a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0",
        "scripts": {
          "start": "echo Starting",
          "test": "echo Testing"
        }
      }
    JSON

    output = shell_output("#{bin}/rum #{testpath}/package.json --help")
    assert_match "TUI to list, filter and run package.json scripts", output
  end
end
