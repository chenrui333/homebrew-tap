class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.123.0.tgz"
  sha256 "c0717eea34a6b92511c206aab1599b033dd4af3e66b0023228c275f08571fecc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca2035fdc0535376ab26efa04cc463654c48b387f62dedbdba83142b81bd0111"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca2035fdc0535376ab26efa04cc463654c48b387f62dedbdba83142b81bd0111"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca2035fdc0535376ab26efa04cc463654c48b387f62dedbdba83142b81bd0111"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a919e0e884e4f01d0c9e45f8acb9f9ea3c23b3aa4a64b00a5b36c863d4f1fc1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86d7aa063df12c9d8ba46a57b2e535da069489de37ab69f055edaed73c3d1377"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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

    system bin/"code-pushup", "print-config", "--config", "code-pushup.config.ts", "--output", "resolved.json"
    assert_equal "TypeScript migration", JSON.parse((testpath/"resolved.json").read)["plugins"][0]["title"]
  end
end
