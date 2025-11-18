class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.88.0.tgz"
  sha256 "502b79772c2c83ffa388d1e46c6701b0ae23f724b100e3f296358cb3f67098de"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d26c4dcc5329bf89a3fbdda0fec20b9f25fe95af444a4ff119048c43bcf55077"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d26c4dcc5329bf89a3fbdda0fec20b9f25fe95af444a4ff119048c43bcf55077"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d26c4dcc5329bf89a3fbdda0fec20b9f25fe95af444a4ff119048c43bcf55077"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cc8a57bc1e0b3f10b947043862ad3143a22e26b0a2857033c16d61c86f1d2a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb61f4ce8fa9d514f8b33bba5550167d758bb2a117fe15f7dba77d0381eedc49"
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
