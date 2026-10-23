class Xql < Formula
  desc "Query CSV files and SharePoint Lists with SQL"
  homepage "https://github.com/excelano/xql"
  url "https://github.com/excelano/xql/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "4a94efb0c1c96d69be307fd61a219861e7a2e917ebd1d124db2c81d2ea9942aa"
  license "MIT"
  head "https://github.com/excelano/xql.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4c604ccf16454302caeebca968c6a1ed7468a1cb26a655df88b047a584e9c62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4c604ccf16454302caeebca968c6a1ed7468a1cb26a655df88b047a584e9c62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3062e3f07d9bdc1b1b13bf71b67d5922de6a83aea0f58d359d8479868930ad0b"
    sha256 cellar: :any,                 x86_64_linux:  "3aeab05cd3c130688293e665cd578584c05166e5b6cfb4a66bde73d0e350ebc2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/xql"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xql --version")
    (testpath/"input.csv").write("name\nalice\n")
    output = shell_output("#{bin}/xql csv #{testpath}/input.csv --exec 'SELECT name' --mode=csv")
    assert_equal %w[name alice], output.lines.map(&:strip)
  end
end
