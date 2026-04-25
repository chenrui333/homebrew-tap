class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.3.4.tgz"
  sha256 "6bdbd513a08515e7337da25b3d95ef4d64ea4b07be426971ac0bceca668e3403"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6463cbfb3e0d627a2a6e2311cdcaafb97fb02d189c27d8bf200b7c3a7994724"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6463cbfb3e0d627a2a6e2311cdcaafb97fb02d189c27d8bf200b7c3a7994724"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6463cbfb3e0d627a2a6e2311cdcaafb97fb02d189c27d8bf200b7c3a7994724"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58c9f2c54322f92bc4d20786229c4f6efe48cd0bc8eb7ca7d845a18495d6a68d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58c9f2c54322f92bc4d20786229c4f6efe48cd0bc8eb7ca7d845a18495d6a68d"
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
