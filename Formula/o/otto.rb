class Otto < Formula
  desc "JavaScript interpreter in Go (golang)"
  homepage "https://github.com/robertkrimen/otto"
  url "https://github.com/robertkrimen/otto/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "8b9bcc75b86fed76eb0aa981dd470c3911144699d17efe5d7d94f085fc032c37"
  license "MIT"
  head "https://github.com/robertkrimen/otto.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40329c1f77324e3ed55aa1cb32942b7986c8467f703f9a67a73beb86aaca0a7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c375a2cc6649b621060ccc5084300ddc6be221560c2c8c587da9afee3374b9c2"
    sha256 cellar: :any_skip_relocation, ventura:       "4e1ec808f6fba0167f51955e22cc1b98b60515b42b7bbcc653a0c7d278e52bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dfeb4f491ab3068cac5f7ff86e97e4059f4e5d80f26b45cd7273f093deecc3b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./otto"
  end

  test do
    (testpath/"test.js").write <<~JS
      console.log("Hello from Otto!");
    JS

    assert_match "Hello from Otto!", shell_output("#{bin}/otto test.js")
  end
end
