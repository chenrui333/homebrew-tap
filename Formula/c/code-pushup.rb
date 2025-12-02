class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.92.0.tgz"
  sha256 "a0fcd97cbcfb38329b9a89542a1731c0a60a0af3b9d66ca9c0aba84a30292230"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0891255641f87c5695a577f515e00acb0ac987bad685021960a2b4ff029548d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0891255641f87c5695a577f515e00acb0ac987bad685021960a2b4ff029548d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0891255641f87c5695a577f515e00acb0ac987bad685021960a2b4ff029548d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d36d91f31c425175adcc425020c949e69edf90774963886b0cef38a1538be753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdea23d73ff8e642025166513e1c4d3dd16a2884ac3ab118bf4516aceb3f1c42"
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
