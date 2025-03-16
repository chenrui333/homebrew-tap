class Scholar < Formula
  desc "Reference Manager in Go"
  homepage "https://github.com/cgxeiji/scholar"
  url "https://github.com/cgxeiji/scholar/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "9c17246667f0d435dd8e1be63aedc605aa351d749ab865b8b8393e4b9268158f"
  license "MIT"
  head "https://github.com/cgxeiji/scholar.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d6e6d52946934b414e9653087f39a0580ef97fd1288df8d46bdffd4e9efe2f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce364e6cb53e6a388b2986cf4efce165c2f2eda00702666366e94af81b8db817"
    sha256 cellar: :any_skip_relocation, ventura:       "c44d8060f7588e9689ed4a8eb9eef1782f94b65dcd66ce541c8862cacd1da125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06187267c60e87d8312e28ac0135175528fe77c1a213eaa2e50acaebe2e620d9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"scholar", "--help"
  end
end
