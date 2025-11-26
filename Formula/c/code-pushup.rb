class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.90.0.tgz"
  sha256 "ea00d74b62cf69180a232d093fbaf1018a0ae88e5448d1f7e8c3999064266253"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b28815ab0c26a98257234a247e8707e203d346733c3ca2aec95ea943e6762c4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b28815ab0c26a98257234a247e8707e203d346733c3ca2aec95ea943e6762c4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b28815ab0c26a98257234a247e8707e203d346733c3ca2aec95ea943e6762c4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3310b67aef29e6fd8e359775fed04dc93b89816cd9c5a178f1342465041496b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2997d3011e3db6b231e03a0aa3d33bf82f897eb377387bf8b6579b0c548ae85f"
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
