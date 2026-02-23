class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.113.1.tgz"
  sha256 "481835badc08c767148208a6991759d38b2fa0ab1703fec0674f5742dea23531"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5a3d5590b87bdfe6ee3ace2ddbdb5e9a2b15249b21ede8de002765cdb605337"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5a3d5590b87bdfe6ee3ace2ddbdb5e9a2b15249b21ede8de002765cdb605337"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5a3d5590b87bdfe6ee3ace2ddbdb5e9a2b15249b21ede8de002765cdb605337"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcc68119dce6d07b63a87c87696642248a975975dcf998e98563a0f84848d7a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d91117440ba68b2b02ca1072e028911ac6fb8bf273a4118d6374f736883f9dec"
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
