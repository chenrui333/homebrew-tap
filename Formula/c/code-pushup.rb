class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.86.0.tgz"
  sha256 "603279ad4eaba4840c069ae9b4c9e8dbc24c211ed6e30e24254d1ec77dcd132f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "557548e20381e2f29b6914f40ec01007ac68a29ecd25bda229f02d7d6c72a681"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "557548e20381e2f29b6914f40ec01007ac68a29ecd25bda229f02d7d6c72a681"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "557548e20381e2f29b6914f40ec01007ac68a29ecd25bda229f02d7d6c72a681"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1550fde70b1ec74fffc0db2e3887f718d921d8005eb40810940412b3dfa50bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7365e5779bd3636ab4a4cb70753a2cfed27641deed535b6ce0fafd687e3268d8"
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
