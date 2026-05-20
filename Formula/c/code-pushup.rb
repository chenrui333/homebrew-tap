class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.126.3.tgz"
  sha256 "1aed714a73b2ed23d5622b3418b887b195c434b7454c72ab142cc8af2b2ddd63"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67fe7651b6c83f382e4590bf81d659dad241c6690f0f339bcb03605d592a2bae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67fe7651b6c83f382e4590bf81d659dad241c6690f0f339bcb03605d592a2bae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67fe7651b6c83f382e4590bf81d659dad241c6690f0f339bcb03605d592a2bae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0512c257641300d9121b4ebb83920f4b536d773b15db60c8fadb43e1204c3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c86449c5e4585da153bcfbd837f2d0c7c5eb56b80d405e1854992a3912575e4b"
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
