class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.90.0.tgz"
  sha256 "ea00d74b62cf69180a232d093fbaf1018a0ae88e5448d1f7e8c3999064266253"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00176b5578422bdaf0bbfd6f88fb9e098f991e6a23e0d9fba9d55e448626fbd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00176b5578422bdaf0bbfd6f88fb9e098f991e6a23e0d9fba9d55e448626fbd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00176b5578422bdaf0bbfd6f88fb9e098f991e6a23e0d9fba9d55e448626fbd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58e48cdf8088e4e2bd7e9ceb269a086c02c999343961e132f11f6df0927e9bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8036c58c38980a33f5fd0dd52e1201f67c884e6aa4a55ade86c6aac849d73cf6"
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
