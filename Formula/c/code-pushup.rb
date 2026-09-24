class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.126.4.tgz"
  sha256 "e02716acb07b65a6d2c055b028ee63ef3712004d0255895e9ea4676d6153c012"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c28c0b0c01f8b2fd90d2103adafe87d97a5fd2a2037539f34ea1007e0638606"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c28c0b0c01f8b2fd90d2103adafe87d97a5fd2a2037539f34ea1007e0638606"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6beff4812f924b1ceb95f2b5bff32a0a04ef3e0990bcf2bf2ae90e54e1a145f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1515b2c67d62499253b9b354a36c4092f1c587e977a729385117aa3026abce94"
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
