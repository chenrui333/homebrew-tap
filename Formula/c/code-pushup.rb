class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.125.0.tgz"
  sha256 "9bb8fcf91d9c4980b426c2e806271fb86bdd1e5c6372d5db46038c6718963e4f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f23549f0e630085e217b49a203617f976cc90fcb4197713ecd9db36091ce05f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f23549f0e630085e217b49a203617f976cc90fcb4197713ecd9db36091ce05f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f23549f0e630085e217b49a203617f976cc90fcb4197713ecd9db36091ce05f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57b6f3c8142a8dac9b6fd349f4ed6b59de58cb41b56b16a1c1a4bca735dbd8b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a11d43a78e049773a430f1c45f95dc4061d3be644bda6c9c7ae4e7e20103c7b0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/code-pushup --version")

    (testpath/"code-pushup.config.ts").write <<~TS
      import { dirname } from 'node:path';
      import { fileURLToPath } from 'node:url';

      const config = {
        plugins: [
          {
            slug: 'ts-migration',
            title: 'TypeScript migration',
            icon: 'typescript',
            audits: [
              {
                slug: 'ts-files',
                title: 'Source files converted from JavaScript to TypeScript',
              },
            ],
            runner: async () => {
              const jsPaths = paths.filter(path => path.endsWith('.js'));
              const tsPaths = paths.filter(path => path.endsWith('.ts'));
              const jsFileCount = jsPaths.length;
              const tsFileCount = tsPaths.length;
              const ratio = tsFileCount / (jsFileCount + tsFileCount);
              const percentage = Math.round(ratio * 100);
              return [
                {
                  slug: 'ts-files',
                  value: percentage,
                  score: ratio,
                  displayValue: `${percentage}% converted`,
                  details: {
                    issues: jsPaths.map(file => ({
                      message: 'Use .ts file extension instead of .js',
                      severity: 'warning',
                      source: { file },
                    })),
                  },
                },
              ];
            },
          },
        ],
      };

      export default config;
    TS

    system bin/"code-pushup", "print-config", "--config", "code-pushup.config.ts", "--output", "resolved.json"
    assert_equal "TypeScript migration", JSON.parse((testpath/"resolved.json").read)["plugins"][0]["title"]
  end
end
