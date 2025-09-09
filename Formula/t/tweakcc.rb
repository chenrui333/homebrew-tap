class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-1.5.1.tgz"
  sha256 "b0363362537e91a7562cc2d080f989401a95b6aafc15a29bb1237ce5690ea88e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51514929dd4a648b2d010a6b8b7c39719eb8578ed9434d2261655b760c02ed73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39a23c879eedbde48554fec4e9158c6cf7a40bb9577e9af11972d539cb932c9a"
    sha256 cellar: :any_skip_relocation, ventura:       "c9ac34a2c147331e87e923da09bde5a0aa4d3feab2b332c9353de2c7b8f9b98d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f332c52214ff8c016fe80619ac3888d444a86957222c53103d2bbcb803e39e3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end
