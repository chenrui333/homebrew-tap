class TypeuiSh < Formula
  desc "Generate design-system skill markdown files for AI providers"
  homepage "https://www.typeui.sh"
  url "https://github.com/bergside/typeui.sh/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "aa813fb32d8d4da51e244bc606dd4fe1aec407c74da01446bb6b1d025cf383e3"
  license "MIT"
  head "https://github.com/bergside/typeui.sh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "aa23905a0e681acb944a5a35dffb3b0555cdf04ed9e92c0662171532a6e15cd0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(prefix: false), "--include=dev"
    system "npm", "run", "build"
    system "npm", "pack"
    system "npm", "install", *std_npm_args, "typeui.sh-#{version}.tgz"

    bin.install_symlink libexec/"bin/typeui.sh"
  end

  test do
    help = shell_output("#{bin}/typeui.sh --help")
    assert_match "generate [options]", help

    (testpath/"generate.js").write <<~JS
      const { runGeneration } = require("#{libexec}/lib/node_modules/typeui.sh/dist/generation/runGeneration.js");

      async function main() {
        await runGeneration({
          projectRoot: process.cwd(),
          providers: ["universal", "codex"],
          designSystem: {
            productName: "Formula Test",
            brandSummary: "Offline test design system.",
            visualStyle: "modern, clean, high-contrast",
            typographyScale: "12/14/16/20/24/32 | Fonts: primary=Inter, display=Inter, mono=JetBrains Mono | weights=400, 500, 600, 700",
            colorPalette: "primary, neutral, success, warning, danger | Tokens: primary=#3B82F6, secondary=#8B5CF6, success=#16A34A, warning=#D97706, danger=#DC2626, surface=#FFFFFF, text=#111827",
            spacingScale: "4/8/12/16/24/32",
            accessibilityRequirements: "WCAG 2.2 AA, keyboard-first interactions, visible focus states",
            writingTone: "concise, confident, helpful",
            doRules: [
              "prefer semantic tokens over raw values",
              "preserve visual hierarchy",
              "keep interaction states explicit",
            ],
            dontRules: [
              "avoid low contrast text",
              "avoid inconsistent spacing rhythm",
              "avoid ambiguous labels",
            ],
          },
          metadata: {
            name: "formula-test-skill",
            description: "Formula test design system",
          },
          dryRun: false,
        });
      }

      main().catch((error) => {
        console.error(error);
        process.exitCode = 1;
      });
    JS

    system Formula["node"].opt_bin/"node", testpath/"generate.js"

    universal = testpath/".agents/skills/design-system/SKILL.md"
    codex = testpath/".codex/skills/design-system/SKILL.md"
    assert_path_exists universal
    assert_path_exists codex
    assert_match "Formula Test Design System Skill (Universal)", universal.read
    assert_match "Formula Test Design System Skill (Codex)", codex.read
  end
end
