class CodePushup < Formula
  desc "CLI to run all kinds of code quality measurements"
  homepage "https://code-pushup.dev/"
  url "https://registry.npmjs.org/@code-pushup/cli/-/cli-0.120.0.tgz"
  sha256 "2afe1eccac06b111a50cb3d052c6660f0bcf3f7104209e3315b178a1482bf8f5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "356e873da20af67d2409b5ac105f14d9b4a05ee6d1cc9378bd6711f23cc38c7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "356e873da20af67d2409b5ac105f14d9b4a05ee6d1cc9378bd6711f23cc38c7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "356e873da20af67d2409b5ac105f14d9b4a05ee6d1cc9378bd6711f23cc38c7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5efef9752fcb90f5b7b5eddbe8028e67f31c4e4b3a0848ddf17a3bcd3eb57ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "177305cfa66ab2ca6491d63d81154d5c2bd49674d4a9f21dc2482d05a3a407aa"
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
