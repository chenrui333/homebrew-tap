class ConfigFileValidator < Formula
  desc "CLI tool to validate different configuration file types"
  homepage "https://boeing.github.io/config-file-validator/"
  url "https://github.com/Boeing/config-file-validator/archive/refs/tags/v1.81.tar.gz"
  sha256 "7fec695580da86795834678e9f24559f503ba01d5643a514937895030f67eb94"
  license "Apache-2.0"
  head "https://github.com/Boeing/config-file-validator.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d2bb7c1c3dae4a84b8da30cc3ce2f7f387a22ebf03bf846d83dafd0f34b1d60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e37e301a2612ca04e3884dd48da1c5c17f7dce1284d82cddf0339bacbbc9091"
    sha256 cellar: :any_skip_relocation, ventura:       "e40ed90826baeaa5f11effe21607b9bc1e69ba8f5d0ab9819126d10fdfe75283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dfec46e4ab22bf5a38ff730153c4b2cffbc728bbc2d5e5083876208dbf52db8"
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
