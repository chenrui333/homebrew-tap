class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.77.0.tgz"
  sha256 "fb4cfb94b78a2e3feb3a2c8e98faaceccc7b8e3a518572afa7bb58290dbffd17"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02f2cef67a685af415b3271b0bfe42ba55d3c6efcc66452a64244824e2df5f81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39ca7bf386190ab2492f8792e2c0b0fb51733936822f5c57207be131cf75defc"
    sha256 cellar: :any_skip_relocation, ventura:       "32cfa1cb530dee50b1d6fec8f8fab59c813c355ff807d77f3c3b5762201bf863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05ab8594b9dbd2ed5ef0949ab6da346c836f3b28e88d9f9e16f23895b59470ff"
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
