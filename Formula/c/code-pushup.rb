class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.120.1.tgz"
  sha256 "c49d0a6c6b4e2c79902d1e4ae7538ccac92431316c3f760f8f8b75032c654fcc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "121179de0f21065f78f880ae744927dce9638caafaa0775048d706d739941db6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "121179de0f21065f78f880ae744927dce9638caafaa0775048d706d739941db6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "121179de0f21065f78f880ae744927dce9638caafaa0775048d706d739941db6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fad1cacff49121790c2c4f562b90096eab543eaafe5410246a53e285f1dbacb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "870c15ef6b630acce4f06a9fde9ef00980f0a5b04ba9845833de2c8d7c47fa07"
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
