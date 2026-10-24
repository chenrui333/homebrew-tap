class Xql < Formula
  desc "Query CSV files and SharePoint Lists with SQL"
  homepage "https://github.com/excelano/xql"
  url "https://github.com/excelano/xql/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "07e8e34e3229ce76e294e2594cb46a65ec2146daa384f1bdf4ece82a26924ca6"
  license "MIT"
  head "https://github.com/excelano/xql.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dccf040fc15252340497dfdef660aedbe8559aff39652544b94d99b785cf6b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dccf040fc15252340497dfdef660aedbe8559aff39652544b94d99b785cf6b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1f749e97fae65a5c0b2e7b8a60cf2c4557e20689243ea44553b6b9a575858b3"
    sha256 cellar: :any,                 x86_64_linux:  "d004d8bf03261ef4316cb7b32375acb3690e7c7aac8d778bcad49651024f537f"
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
