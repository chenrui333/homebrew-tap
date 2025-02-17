class Ghalint < Formula
  desc "GitHub Actions linter"
  homepage "https://github.com/suzuki-shunsuke/ghalint"
  url "https://github.com/suzuki-shunsuke/ghalint/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "868cba9d97d07095c8f632ac4d7f0275f6a36a6d34adcdb8d80b191284476047"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/ghalint.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e380478f528bee2702103f19d614380eceeffc85777a6181e6217409f396742"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31be4fed25ed5653666abaeab312090ff6cf01f0f80bd410ef3cb31ff025370e"
    sha256 cellar: :any_skip_relocation, ventura:       "357119dfa76b0fbcc26dde13f35523b263cba564f785e478301bf96fc23f5e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "730ba3e9411c0d2c5393f78b6de9cc533e065932416fae8058ea11cf2ee2cbea"
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
