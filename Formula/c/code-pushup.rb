class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.88.0.tgz"
  sha256 "502b79772c2c83ffa388d1e46c6701b0ae23f724b100e3f296358cb3f67098de"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64ea42156201c5dbf5f5a4a0711fb767e2e09d318784ea420abff986d9c9dd59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64ea42156201c5dbf5f5a4a0711fb767e2e09d318784ea420abff986d9c9dd59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64ea42156201c5dbf5f5a4a0711fb767e2e09d318784ea420abff986d9c9dd59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9ca9b8ae6e408c8d8f2db7e5c71601666a31bb06ede5bb1179e7d68dad553aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ef79ac64746e36677cedc5b45af3d39896e9d521063c30e234a792961a6d137"
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
