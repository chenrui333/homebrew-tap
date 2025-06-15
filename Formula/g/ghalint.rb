class Ghalint < Formula
  desc "GitHub Actions linter"
  homepage "https://github.com/suzuki-shunsuke/ghalint"
  url "https://github.com/suzuki-shunsuke/ghalint/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "ccd597e0f943295a5303125342b96913f8fe3b71676bde4113230ae38536d47b"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/ghalint.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "306a574ddd02a6bc028da54b3f3b7ee92fca09631a5b36c309d97befaed1bff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6500664bc8bc6c1e79a78c632c6cbc83dedefed36647ada43efade6a288b3574"
    sha256 cellar: :any_skip_relocation, ventura:       "6bb00acafc87652941d266766da6c9fce5335c4741c00eb3222d883a7a7f235f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65c0bd04a61ae166249fb74ae9d083c47d8231bc53364e6c544500486bcf20a6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ghalint"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghalint version")

    (testpath/".github/workflows/test.yml").write <<~YAML
      name: test

      on: [push]

      jobs:
        test:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/ghalint run .github/workflows/test.yml 2>&1", 1)
    assert_match "job should have permissions", output
  end
end
