class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.91.0.tgz"
  sha256 "35111de0ad705a3104e8f986d812d89496ba3fe2cd7a5b167edd7035bea00f1e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "098180b54af7c1245628d62d885e0a3125c31b2f94144353244b3be60e2550b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "098180b54af7c1245628d62d885e0a3125c31b2f94144353244b3be60e2550b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "098180b54af7c1245628d62d885e0a3125c31b2f94144353244b3be60e2550b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de7866f153119828a5f3aa6ab04f2efea85f031fdc18cb7f991720e24d2e12ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c97fe8ac0b00a01dc43ddf037ca1e4a2b89337294aa532795acf5035eb61e96f"
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
