class Wrkflw < Formula
  desc "Validate and execute GitHub Actions workflows locally"
  homepage "https://github.com/bahdotsh/wrkflw"
  url "https://github.com/bahdotsh/wrkflw/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "d8f2652587317c07dbb146654955774edd61b79abf9232b261ba0641d0da90d4"
  license "MIT"
  head "https://github.com/bahdotsh/wrkflw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0ebdd96231b3301220c4cf9f4cd44924e342b4b92a09f57a4958d425ef64568"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1e0c4fc7e2c85331a55be077fccf5498d28462dd33850ca13eade043c33c313"
    sha256 cellar: :any_skip_relocation, ventura:       "655c38a15b2b69bd52c0874a1fb0962ccf2ac26fe7f7c130641ad9560b8b20b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87bf2064963dcb90e7788fce98291483188fc8a1e51d636a6226a595a2e6ce56"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrkflw --version")

    test_action_config = testpath/".github/workflows/test.yml"
    test_action_config.write <<~YAML
      name: test

      on: [push]

      jobs:
        test:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/wrkflw validate #{test_action_config}")
    assert_match "Summary: 1 valid, 0 invalid", output
  end
end
