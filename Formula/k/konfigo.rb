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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e9f380619933b3ea6ad375d750bc00ee643194dd5242a8f99c9034c986db023"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e9f380619933b3ea6ad375d750bc00ee643194dd5242a8f99c9034c986db023"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e9f380619933b3ea6ad375d750bc00ee643194dd5242a8f99c9034c986db023"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68371e20332f9f16648a98cf5581fe28c0cd828eb176ec2b82bd172aaadb66b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b1958d6f5b729a19187016518bd4f9b82ea6dc5140238c30f7991bb5984279b"
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
