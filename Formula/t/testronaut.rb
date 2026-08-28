class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.5.0.tgz"
  sha256 "1b2163dc7b0284a3d9c6024391db8a75c1b300ff8b944181d543925f8c734130"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cf296d58d6df1de2353e9e1bb2f3bac777eb7b51b468cf57b66aa6c1b8c7450"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cf296d58d6df1de2353e9e1bb2f3bac777eb7b51b468cf57b66aa6c1b8c7450"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cf296d58d6df1de2353e9e1bb2f3bac777eb7b51b468cf57b66aa6c1b8c7450"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78d6879230ad71e58622f78ee2d5b3f8a2679199b0c1361a47cbb722e6e080bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78d6879230ad71e58622f78ee2d5b3f8a2679199b0c1361a47cbb722e6e080bb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/testronaut 2>&1", 1)
    assert_match "Missions directory not found: missions", output

    output = shell_output("#{bin}/testronaut serve 2>&1", 1)
    assert_match "No HTML reports found in missions/mission_reports", output
  end
end
