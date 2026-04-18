class Gowebly < Formula
  desc "Next-generation CLI tool to easily build amazing web applications"
  homepage "https://gowebly.org/"
  url "https://github.com/gowebly/gowebly/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "2f197e1f5e151001af5b97e9ecc4d49a38a685260dbffcd38c8bea0a7799230a"
  license "Apache-2.0"
  head "https://github.com/gowebly/gowebly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f135b11e10a73e64ad0152cc56391fd949010a2a2113ee854e002dc0e5b78371"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f135b11e10a73e64ad0152cc56391fd949010a2a2113ee854e002dc0e5b78371"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f135b11e10a73e64ad0152cc56391fd949010a2a2113ee854e002dc0e5b78371"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "577f99c096be84ac13e7ae1b797a178c002c2e9c77bbe847b70812548c238046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfe30a245aa63649670e11963a6105d77248cc759e8b61c66674294a389f0dd4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowebly doctor")

    output = shell_output("#{bin}/gowebly run 2>&1", 1)
    assert_match "No rule to make target", output
  end
end
