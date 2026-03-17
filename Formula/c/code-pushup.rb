class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.120.0.tgz"
  sha256 "2afe1eccac06b111a50cb3d052c6660f0bcf3f7104209e3315b178a1482bf8f5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7126c507f1ae708e7e51dd56527ad401409e6a193a2c5e8255f92421d2c6568a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7126c507f1ae708e7e51dd56527ad401409e6a193a2c5e8255f92421d2c6568a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7126c507f1ae708e7e51dd56527ad401409e6a193a2c5e8255f92421d2c6568a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f21b8e460c496fd1c33c0a80b4196181d96b88d3187bed43544e2f1c1e5d41d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c561eeaf17859e0761d2e04a087207523f0b004dcc23f49d53b28aefdc1ec2c6"
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
