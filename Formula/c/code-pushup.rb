class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.87.0.tgz"
  sha256 "4144fe0be60e2f67ce1f82375dac49301d6e85c37fad15331a22eef5cfaf4f0f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b418099ad44cbef7c5eb82040ff3006144be94b373c5f9a9659241ff23960e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b418099ad44cbef7c5eb82040ff3006144be94b373c5f9a9659241ff23960e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b418099ad44cbef7c5eb82040ff3006144be94b373c5f9a9659241ff23960e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86d3a91ecdbc4112ddc6f6f9c340a888686d1d9cda99488c0c3004764e0b9c7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a9cc54af406978c6cf9311cc9c1538e9f6e7eeffe0fb8613d5de57fd3bcf742"
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
