class Sttr < Formula
  desc "CLI to perform various operations on string"
  homepage "https://github.com/abhimanyu003/sttr"
  url "https://github.com/abhimanyu003/sttr/archive/refs/tags/v0.2.24.tar.gz"
  sha256 "e9340c65c22d3016f9e4fe0a7f414bd1a8d8463203806c28b09a79889c805d76"
  license "MIT"
  head "https://github.com/abhimanyu003/sttr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aca3fc9da1ae6a6382227fa4f34df1a44b3741982b23549b3d39593c15572b18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22bb4866cfed55da1efd316ecc54e54740d69f341d3f39100f7d722fe40c3f0e"
    sha256 cellar: :any_skip_relocation, ventura:       "ba3643d70584b7c40c3fec5e90a741f4a80753c3da3cc9fcc901c66769d33d4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb3080c90ab6b978ecb95336003e948d748f302262e8ce65bd012b8309c0f261"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sttr version")

    assert_equal "foobar", shell_output("#{bin}/sttr reverse raboof")

    output = shell_output("#{bin}/sttr sha1 foobar")
    assert_equal "8843d7f92416211de9ebb963ff4ce28125932878", output

    assert_equal "good_test", shell_output("#{bin}/sttr snake 'good test'")
  end
end
