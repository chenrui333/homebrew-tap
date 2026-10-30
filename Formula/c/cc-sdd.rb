class CcSdd < Formula
  desc "Spec-driven development harness for AI coding agents"
  homepage "https://github.com/gotalab/cc-sdd"
  url "https://registry.npmjs.org/cc-sdd/-/cc-sdd-3.1.0.tgz"
  sha256 "e13cb80735c7fb2d72bdb4a7e4d130ce65065140fbb13a33725e27929506ca95"
  license "MIT"
  head "https://github.com/gotalab/cc-sdd.git", branch: "main"

  depends_on "node"

  deny_network_access!

  def fetch
    return unless build.head?

    cd "tools/cc-sdd" do
      system "npm", "install", *std_npm_args(prefix: false)
    end
  end

  def install
    if build.head?
      cd "tools/cc-sdd" do
        system "npm", "install", "--offline", *std_npm_args(prefix: false)
        system "npm", "run", "build"
        system "npm", "install", "--offline", *std_npm_args
      end
    else
      system "npm", "install", "--offline", *std_npm_args
    end
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cc-sdd --version")

    system bin/"cc-sdd", "--claude-skills", "--lang", "en", "--yes"
    assert_match "# Spec Initialization", (testpath/".claude/skills/kiro-spec-init/SKILL.md").read
    assert_path_exists testpath/".kiro/settings/templates/specs/init.json"
  end
end
