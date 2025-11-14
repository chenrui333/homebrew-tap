class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.87.2.tgz"
  sha256 "c0b9aeb7199f5a0a2d07b75766119e7b2fd19f00a31fbd3781f824b9a7cb207d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ddf58d2e597cfb0425f56b7277fab447250501b07185fd256644ecaaf532b77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ddf58d2e597cfb0425f56b7277fab447250501b07185fd256644ecaaf532b77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ddf58d2e597cfb0425f56b7277fab447250501b07185fd256644ecaaf532b77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e962ebe46b44c71606c2304a9e24d7ce8169aa5b3b322a4d20aafea401e809d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "349c12ac25c12b70a3a82ebea32d35a5e0954bcd2a82d5938faa4937e6e0c171"
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
