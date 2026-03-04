class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.116.0.tgz"
  sha256 "5d8cff90d05402bda6ca83d9c68291452518bbfba4f18eb8a4967223c1b45009"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95f47fc4ae010cf6868e21295cd3f7e06d25b8ae68cb7a3616d8e6ddf96ad338"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95f47fc4ae010cf6868e21295cd3f7e06d25b8ae68cb7a3616d8e6ddf96ad338"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95f47fc4ae010cf6868e21295cd3f7e06d25b8ae68cb7a3616d8e6ddf96ad338"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a876891f09725f0c79332737a78d06123ab44cbd05f0f9a0031fb31e2ca310a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "978980c6a73b47c7707f6d09f502f74999d53e133693728d9b040298bbdce3d6"
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
