class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.110.0.tgz"
  sha256 "f7f58d3b2e872eaf23042b7a012ec211f845194d09e7a2a56f8f2aec713f3a8e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91ed0d18342f66b1735056d5b2f9d08b148c8dda46077e84066f93db871f4883"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91ed0d18342f66b1735056d5b2f9d08b148c8dda46077e84066f93db871f4883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91ed0d18342f66b1735056d5b2f9d08b148c8dda46077e84066f93db871f4883"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef345c2bcdc44b572c76341a7b38544445f52c3a71ac7d789f7760dec0542276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4e54e6dfabe611c0a140262aec50798d20ab0fda96ba359137de8c6415f061c"
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
