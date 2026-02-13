class Openspec < Formula
  desc "AI-native system for spec-driven development"
  homepage "https://github.com/Fission-AI/OpenSpec"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.1.1.tgz"
  sha256 "e943e2137f86bb6772f1a5ec2fb725fd4302b590de0515a0349364ba419e033c"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openspec --version")

    output = shell_output("#{bin}/openspec init --tools codex")
    assert_match "OpenSpec structure created", output
    assert_match "name: openspec-sync-specs", (testpath/".codex/skills/openspec-sync-specs/SKILL.md").read
  end
end
