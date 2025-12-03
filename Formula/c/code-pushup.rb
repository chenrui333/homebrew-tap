class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.92.1.tgz"
  sha256 "25997648a35b6539e853d1a256c37ee6c597ca0d85ac23edfcdae240b3b851f3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "594caa528f13f00d0e5cb8326dbba34136321a9524e4914b566c22479bb86773"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "594caa528f13f00d0e5cb8326dbba34136321a9524e4914b566c22479bb86773"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "594caa528f13f00d0e5cb8326dbba34136321a9524e4914b566c22479bb86773"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc5bb618a9711ef91998573db0f10a04d282f6feb17369a5fd2c4dcd2ada375d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "528c2e353ba507c5c6f1bfdf1677b93695cb4e103a118ccb500b17266a5fc969"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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

    output = shell_output("#{bin}/code-pushup print-config --config code-pushup.config.ts 2>&1")
    assert_equal "TypeScript migration", JSON.parse(output)["plugins"][0]["title"]
  end
end
