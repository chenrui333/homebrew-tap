class Ghalint < Formula
  desc "GitHub Actions linter"
  homepage "https://github.com/suzuki-shunsuke/ghalint"
  url "https://github.com/suzuki-shunsuke/ghalint/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "e3c01a807f8aff512d78f65bdf6141a7b9fa6337e413f0ff945514d6b75c352f"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/ghalint.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78239c3b79ceea86e7e9da5a0af3adf11aa4d87c50ce86bff4fe7a6d81955453"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e6e49d08aa88092198ebc575f3d0d4449c29076bad9fabb3152c4f6f1a01d56"
    sha256 cellar: :any_skip_relocation, ventura:       "dabf1b77e0bc7ed53db5983efd31e77429d1d6a15c8fa3d07af3c6b8220746b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0063b9a861c7196c69370206e520eabc6da3267b1cbb41d3c1224e3fe7e83a05"
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
