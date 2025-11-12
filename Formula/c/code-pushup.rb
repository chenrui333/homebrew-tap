class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.87.0.tgz"
  sha256 "4144fe0be60e2f67ce1f82375dac49301d6e85c37fad15331a22eef5cfaf4f0f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef1b7b41e5b95d214c8913ea907e733c594dd53df1f4c6eb115e9188f3ed37ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef1b7b41e5b95d214c8913ea907e733c594dd53df1f4c6eb115e9188f3ed37ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef1b7b41e5b95d214c8913ea907e733c594dd53df1f4c6eb115e9188f3ed37ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8697dff158716d255912248ee06738ec17ac7c92ff042df99cc53fbc35e12408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7d6fbf26814974a9c8997f34927b25bb72d09a80dd8511812bfe627419c7edf"
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
