class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.84.0.tgz"
  sha256 "54ef83a6244ccf3bb8e40285f6473e39d009ff972aa1baaf9354eb4de5a5df61"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d3edf10898d84173646f1a8e35faec06c063a515ebdd7b47a9abd2c06ab48ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d3edf10898d84173646f1a8e35faec06c063a515ebdd7b47a9abd2c06ab48ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d3edf10898d84173646f1a8e35faec06c063a515ebdd7b47a9abd2c06ab48ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c95fb36fec067b5471e1a9e2df2fce1bed82d9c3e86a7f316b6ff961c93b4f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "821f4fa25dd34bc13d5173de00af77a89d98e5871cce9d3f4ce997a8957fa774"
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
