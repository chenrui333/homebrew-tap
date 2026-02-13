class Openspec < Formula
  desc "AI-native system for spec-driven development"
  homepage "https://github.com/Fission-AI/OpenSpec"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.1.1.tgz"
  sha256 "e943e2137f86bb6772f1a5ec2fb725fd4302b590de0515a0349364ba419e033c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf53641b49901614bda2ca4fa2c611f27be4705cf7a0e874e928fda1ef95bd56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf53641b49901614bda2ca4fa2c611f27be4705cf7a0e874e928fda1ef95bd56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf53641b49901614bda2ca4fa2c611f27be4705cf7a0e874e928fda1ef95bd56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e500c30cc325f4eb0ebed82821be4c8a109dc02c5ea77d6f4c4ff01d8c5429c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e500c30cc325f4eb0ebed82821be4c8a109dc02c5ea77d6f4c4ff01d8c5429c"
  end

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
