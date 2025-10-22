class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.81.0.tgz"
  sha256 "084393f67798a241a4c846dc486afd9d742d0154e1f978b229c4d082c95ead64"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c950f175c40d8f4c0b75aacf4ccc185b905787116540a9512ed0a734ceae8f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c950f175c40d8f4c0b75aacf4ccc185b905787116540a9512ed0a734ceae8f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c950f175c40d8f4c0b75aacf4ccc185b905787116540a9512ed0a734ceae8f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e84c580dd9360164e1f89328500ff4c5b33cbbc25f43b75336c0dcb36073ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a82819449a92f2250306f72af47474272a37cee75d047e67c75a8c004601c2e3"
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
