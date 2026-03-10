class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.117.0.tgz"
  sha256 "c867f2712476fbd1d4a8a8994979fd58c8f9bcef9c635b1a8f546eaad28f4caa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c607742d59436a6cc9131b94416b88adf166c2f5bb3e087d58da98e65c873794"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c607742d59436a6cc9131b94416b88adf166c2f5bb3e087d58da98e65c873794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c607742d59436a6cc9131b94416b88adf166c2f5bb3e087d58da98e65c873794"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "422096f7840f3c42c82b868e4d16ee7d0be31b1115ceae39387b1631aa170c0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e82a22f02a7509ab638b2ff0b3bf104af27c3ef029c5f0f7b0928543d8cb496c"
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
