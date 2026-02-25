class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.115.0.tgz"
  sha256 "22de80507ea20b12b3285f262e6e976babcce74dcbe371b90dbbdec080befe3b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9327aa55eed6e66a4e6a77c77a6bef0bd7767cd7a93a86b7cb2fc5612783b1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9327aa55eed6e66a4e6a77c77a6bef0bd7767cd7a93a86b7cb2fc5612783b1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9327aa55eed6e66a4e6a77c77a6bef0bd7767cd7a93a86b7cb2fc5612783b1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57a267f9171baf8d715945d950086a8b216445554dfba99ad3d83983a29f5037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a0b981bfd86e6e17be55a5e54984473ff9590e1dd16cc10e9de2ad6f1436cdd"
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
