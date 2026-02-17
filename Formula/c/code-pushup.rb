class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.113.0.tgz"
  sha256 "6e974d3ab85d6699d49a00b0e453c3a0633af353fab2004b613fb36d67b57fa9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b39bc3283fb7041a40ad552794d5934b42392f068713a424adb37fd3a76708a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b39bc3283fb7041a40ad552794d5934b42392f068713a424adb37fd3a76708a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b39bc3283fb7041a40ad552794d5934b42392f068713a424adb37fd3a76708a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1373ac14e989d0bd30d93e4acec414feae2b4b122be20fdee064a90cc2a8c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d420163c8bbfc5ca96efbcc2494b850c0299b0ea15849c30737a8100e1e85c1"
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
