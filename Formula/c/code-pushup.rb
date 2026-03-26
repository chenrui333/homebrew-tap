class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.124.0.tgz"
  sha256 "dbbcc23dab39cf5d22ee7800c24f2e996608004ebdfdea03c4a35d9980a8418e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61884255b9b8f3faa59ce55c5bff312fd79851e17caf1ea0e4c9d752a0647787"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61884255b9b8f3faa59ce55c5bff312fd79851e17caf1ea0e4c9d752a0647787"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61884255b9b8f3faa59ce55c5bff312fd79851e17caf1ea0e4c9d752a0647787"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4a56f50266699bbf7a8115e5586c2c73f199ce9ee2fb52be6b7a4b6ebbc6cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6d1ab90e4ede6a97aa75d2dbcb13ce65276b10b9b02d943a850fd8f092944ae"
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
