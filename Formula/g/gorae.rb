class Gorae < Formula
  desc "TUI librarian for PDFs and EPUBs"
  homepage "https://github.com/Han8931/gorae"
  url "https://github.com/Han8931/gorae/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "ff04dab6b7b480d5d67a8f3f463b80ef0de9cae52cf13e827b9bb6d24e008106"
  license "MIT"
  head "https://github.com/Han8931/gorae.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99543c6b5d1287905827b124b24d5fc133ac95077b9829c1871b55c5ec11b0cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99543c6b5d1287905827b124b24d5fc133ac95077b9829c1871b55c5ec11b0cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99543c6b5d1287905827b124b24d5fc133ac95077b9829c1871b55c5ec11b0cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "954b3a2a25ed2f594ef011d4fa0e6cadc55a598361bd2f42c75eb2f9e8a7694a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07238b61cffea0b65aa531c93a793caf88b6d00ddcae9b5ad568c38ba84929b8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gorae"
  end

  test do
    assert_match "Root directory to start in", shell_output("#{bin}/gorae --help 2>&1")
  end
end
