class Tornado < Formula
  desc "SQLite explorer with Vim key bindings"
  homepage "https://codeberg.org/ozeye/tornado"
  url "https://codeberg.org/ozeye/tornado/archive/v0.5.0.tar.gz"
  sha256 "9f7741f41e439bca5065ff044b188390e4039e81e55e0ace13798baff10aac27"
  license "MIT"
  head "https://codeberg.org/ozeye/tornado.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d950585ac59c67169de0eaedefc94ec930ed6239e612ea28085e37415fddc25c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d950585ac59c67169de0eaedefc94ec930ed6239e612ea28085e37415fddc25c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d950585ac59c67169de0eaedefc94ec930ed6239e612ea28085e37415fddc25c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "653b0c36335bcfdcc54a468666e77ecaec3e629d34c22e1888f75bcfed8f2422"
    sha256 cellar: :any,                 x86_64_linux:  "8f3e189262a64aefeb04c18582fd95a42ece944da36e6db0f8a055f9cc13ca7a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/tornado"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tornado --version")
    assert_match "flag provided but not defined", shell_output("#{bin}/tornado --invalid-option 2>&1", 2)
  end
end
