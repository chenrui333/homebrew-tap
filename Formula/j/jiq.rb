class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.21.1.tar.gz"
  sha256 "d1293631a584f728f76a5eb252c7bae78aa2b993cc80c85fcc6bd871ab6d2d3f"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7c9dc0ed1645305905c77bcc51a11290ffd9045ff6e5aa4667545c148a0ffda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e343571a9437d6eb45174e6ffe7b3ac5de54bbfde3da52d61dcd56be5fa6d87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6af91e7c7b92eed1d9291370275dfaf9bc447a8b3f6e826cb889087962420f84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "079bc799e82c1db92ae4f286a53dc75b1defdefdc4c44adaec1030685844176f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50e2795586547eda755fd2d2cbe5b0dfa4713e8f76a23d60ff382f54dd33c6e5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiq --version")

    (testpath/"data.json").write("{}\n")
    empty_path = testpath/"empty"
    empty_path.mkpath
    output = shell_output("PATH=#{empty_path} #{bin}/jiq #{testpath}/data.json 2>&1", 1)
    assert_match "jq binary not found in PATH.", output
  end
end
