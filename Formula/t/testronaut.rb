class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.4.0.tgz"
  sha256 "abcfb77feda7faa6f78043d010afd2e8013ec3e3bccddd4e2a8d58556096582f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c32a935542aa6c888df1dd080c58a556ead375ee64fde962f1f2db803436ee72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c32a935542aa6c888df1dd080c58a556ead375ee64fde962f1f2db803436ee72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c32a935542aa6c888df1dd080c58a556ead375ee64fde962f1f2db803436ee72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a85791ba6fa4966a6fa4f7c10ea96fcff0b4cbedc02bdf4aefaacd069d396f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a85791ba6fa4966a6fa4f7c10ea96fcff0b4cbedc02bdf4aefaacd069d396f1c"
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
