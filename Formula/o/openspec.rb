class Openspec < Formula
  desc "AI-native system for spec-driven development"
  homepage "https://github.com/Fission-AI/OpenSpec"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.2.0.tgz"
  sha256 "2aceda94693f1db0b0d2ea3c750a2a418737eab30d026d1d066629945cde98ba"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27cb87fdcb2f3bdc156a481df473865839bc883f2b5ed64957cd75ab96bfcc2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27cb87fdcb2f3bdc156a481df473865839bc883f2b5ed64957cd75ab96bfcc2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27cb87fdcb2f3bdc156a481df473865839bc883f2b5ed64957cd75ab96bfcc2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "158d71e73e2b339c07044f47653eebbfcd1c71e6be66025c6b3b0991d82e77ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "158d71e73e2b339c07044f47653eebbfcd1c71e6be66025c6b3b0991d82e77ff"
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
    assert_path_exists testpath/"openspec/specs"
    assert_path_exists testpath/".codex/skills/openspec-propose/SKILL.md"
  end
end
