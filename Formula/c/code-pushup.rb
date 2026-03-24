class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.123.0.tgz"
  sha256 "c0717eea34a6b92511c206aab1599b033dd4af3e66b0023228c275f08571fecc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "355d1ca53c49019e9d01bc97f0d76303f17a08b2d6681f3f57786c94df9b3705"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "355d1ca53c49019e9d01bc97f0d76303f17a08b2d6681f3f57786c94df9b3705"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "355d1ca53c49019e9d01bc97f0d76303f17a08b2d6681f3f57786c94df9b3705"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4018f66d8cdc782dbe5238cf9eaaca42d0b8d555fd208a71a41cdb5dd341609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4e7014de7e924b290b52d0f0a144d47688bcc8ba541a91e6671b99b8fb31c0c"
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
