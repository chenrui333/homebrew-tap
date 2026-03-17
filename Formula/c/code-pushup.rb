class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.119.1.tgz"
  sha256 "d41cebf6969be409818c0e6f8aef88c691a55bfeddedc6c2e6e64c08aad52344"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0d7d6d54ded9ac84b20ddf058741b2bf12d8602d5972e5559d14671f40f1ad1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0d7d6d54ded9ac84b20ddf058741b2bf12d8602d5972e5559d14671f40f1ad1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0d7d6d54ded9ac84b20ddf058741b2bf12d8602d5972e5559d14671f40f1ad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19bf474699b7dc38c8dcace83790f6257ce51756be1d0ccd27ad6c0b7bce257b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2414e5d1a6b606089dec4ae2dc640b1c233dde9537b30fe0125a03c2ba8fbbd7"
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
