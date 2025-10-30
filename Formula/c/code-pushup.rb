class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.84.0.tgz"
  sha256 "54ef83a6244ccf3bb8e40285f6473e39d009ff972aa1baaf9354eb4de5a5df61"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "475f4f16c92216c831cd479ba82d0ea5306b10c698110865648b0c769994537d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "475f4f16c92216c831cd479ba82d0ea5306b10c698110865648b0c769994537d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "475f4f16c92216c831cd479ba82d0ea5306b10c698110865648b0c769994537d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25481ef37f983b9175d9838b1a19868d49b797f1277257020a5a58d8c312fee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edd7221683b1e680642f83362369f7b01341be7078649963a8f6a46736385a41"
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
