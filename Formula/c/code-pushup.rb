class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.118.0.tgz"
  sha256 "16764ccee9efea27cae212aafdc9bdc3c00c6b1c69e1ce987a375d3a389ca145"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4392f4b5a3967f414a7a4c5ce2ecc5171d6c00e988a3b637fb206a6df9499710"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4392f4b5a3967f414a7a4c5ce2ecc5171d6c00e988a3b637fb206a6df9499710"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4392f4b5a3967f414a7a4c5ce2ecc5171d6c00e988a3b637fb206a6df9499710"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6ede775c83f980caa0f3425ff9589ebdf6652ef745f82b5a9dc2d06cd1d8a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7381d3354f476fb147b908e055d97821b5efd19d83950fda2d37b2c40dd42842"
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
