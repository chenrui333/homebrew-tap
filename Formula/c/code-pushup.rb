class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.122.0.tgz"
  sha256 "c8a92406b35f76a1375ce9e9d2244acb677cce317f740dd500532ed3cc1c4c58"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7aff466e878673163a6d545d0dc5319584725c7209e7cd7cddf1d32aaf93ed3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aff466e878673163a6d545d0dc5319584725c7209e7cd7cddf1d32aaf93ed3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7aff466e878673163a6d545d0dc5319584725c7209e7cd7cddf1d32aaf93ed3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3f03c1d7698be809f74396aa2d060fd31fb45572c3491860fbed2b8a6950eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "327b977420e9d37f90e6eef623964c69dbbfc1b34ca1332541418a03c5925a9c"
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
