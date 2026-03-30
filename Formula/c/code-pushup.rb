class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.126.0.tgz"
  sha256 "ab73f93a3ccf1e479537b5beb7fe4c79883c12b974f63351277b172b2b14e308"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe34ce8d95edae400a410b4f225df8ef346de7eaafdc664a68e20da4957fd138"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe34ce8d95edae400a410b4f225df8ef346de7eaafdc664a68e20da4957fd138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe34ce8d95edae400a410b4f225df8ef346de7eaafdc664a68e20da4957fd138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "525990246cef0de7ecabecadcc800f6587e259c9c7e38f679dce2fde6491cedf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ad0a286a9a7a8680c881adcbe5fbc5226dc8313550fc18b0f69e384f16b933d"
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
