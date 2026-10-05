class Konfigo < Formula
  desc "Merge and transform configuration files across multiple formats"
  homepage "https://github.com/ebogdum/konfigo"
  # GitHub regenerated the v2.0.3 archive (same tag commit); pin the tag commit
  url "https://github.com/ebogdum/konfigo.git",
      tag:      "v2.0.3",
      revision: "f2d0164da57f480a717c9e1e7821a9d0146bdcde"
  license "MIT"
  head "https://github.com/ebogdum/konfigo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "371dd9919854510e3db0155040a8e8e50911a2ee1d01c7dbd1a28160efbd28f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "371dd9919854510e3db0155040a8e8e50911a2ee1d01c7dbd1a28160efbd28f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a27e1d048854b64797cf37eb734676a4f4c6bf68cfeb7b970c4d15db97d104d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71e57a587a8724a601971fde826d96a0d4729a9705c6df6af0a12f130c912894"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"konfigo"), "./cmd/konfigo"
  end

  test do
    (testpath/"config1.json").write <<~JSON
      {"a":1,"b":2}
    JSON
    (testpath/"config2.json").write <<~JSON
      {"b":3,"c":4}
    JSON

    output = shell_output("#{bin}/konfigo -s config1.json,config2.json -oj")
    assert_match '"a": 1', output
    assert_match '"b": 3', output
    assert_match '"c": 4', output

    help = shell_output("#{bin}/konfigo -h 2>&1")
    assert_match "Path to a schema file", help
  end
end
