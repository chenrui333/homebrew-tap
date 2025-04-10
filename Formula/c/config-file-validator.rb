class ConfigFileValidator < Formula
  desc "CLI tool to validate different configuration file types"
  homepage "https://boeing.github.io/config-file-validator/"
  url "https://github.com/Boeing/config-file-validator/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "7f87cd0adaea5ad7e311b7b763321001dd64132f1bb56ca33127ca3bae0ce7da"
  license "Apache-2.0"
  head "https://github.com/Boeing/config-file-validator.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2ad24412ecb3637dd309b1bd91f11b724742a503b04f86eb328154c5f3a910c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "504d00dd075eaefeca46e7ee3762d9ad5d16e3383cae367a8da89d69b7bb1e2a"
    sha256 cellar: :any_skip_relocation, ventura:       "c1b9c32e4bf2aeb482d9e4f9e5de0385b05c01530a21139ed1de3a7681f86649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fe58433e2163507972332f0de812fa4a7031aab668bb234bec489470f144481"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Boeing/config-file-validator.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"validator"), "./cmd/validator"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/validator -version")

    test_file = testpath/"test.json"
    test_file.write('{"valid": "json"}')
    assert_match "✓ #{test_file}", shell_output("#{bin}/validator #{test_file}")
  end
end
