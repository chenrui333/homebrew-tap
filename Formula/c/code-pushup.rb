class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.82.0.tgz"
  sha256 "ac40eb5a3f5e5f591eb1ac3f71b1414bace2f60877f09527a96e5d4021a22eba"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a710e633d13de45b85094ad6c8367b317424dd603f48b95e7f47a1418376de4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a710e633d13de45b85094ad6c8367b317424dd603f48b95e7f47a1418376de4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a710e633d13de45b85094ad6c8367b317424dd603f48b95e7f47a1418376de4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d525bc19d48f6282deeccb830768fb79d2de3a34fe8c5f3c107d591af3202a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c2be93c613b54256e00f879fe886be64b0c9609fa00dc06430f2750ed219c18"
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
