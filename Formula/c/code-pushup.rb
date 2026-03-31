class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.126.2.tgz"
  sha256 "cf5a59b5f769366b39ed01b3e3304677a0366af506f8f4f6619d6269b07c2602"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54fd07a1212d68be72511c88ec9a1cbb15cf63e83666d3ff7f5e93581c1970bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54fd07a1212d68be72511c88ec9a1cbb15cf63e83666d3ff7f5e93581c1970bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54fd07a1212d68be72511c88ec9a1cbb15cf63e83666d3ff7f5e93581c1970bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3828a82da037dacfb47760562b28daf1ddf482282bac25304e6b5fe971f8b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95a160332e8f3d95b2b2bff49d850539ace94a2275fc6e3ed3841861eadf8468"
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
