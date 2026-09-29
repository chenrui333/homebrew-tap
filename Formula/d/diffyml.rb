class Diffyml < Formula
  desc "Structural YAML diff tool with Kubernetes intelligence"
  homepage "https://github.com/szhekpisov/diffyml"
  url "https://github.com/szhekpisov/diffyml/archive/a41e4f69d1c39d7d36a9eb1193059ff3879f5664.tar.gz"
  version "1.8.1"
  sha256 "9ffac98cb4cae68e3a222410cb05a1660756a26a81e367b1b334104be9bfccff"
  license "MIT"
  head "https://github.com/szhekpisov/diffyml.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4cb56c2a9c846ce386bc2a5b774a230b2340de19a375ef163c149212aa836e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4cb56c2a9c846ce386bc2a5b774a230b2340de19a375ef163c149212aa836e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4cb56c2a9c846ce386bc2a5b774a230b2340de19a375ef163c149212aa836e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9160e8219a044c940923dd7fb33fe1acc6b9fc5656121444bd8fd3f3c152cb92"
    sha256 cellar: :any,                 x86_64_linux:  "1def8388823840d41d4ce6326213043b305ab252622651e8862ea012d4e40298"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diffyml --version")

    (testpath/"from.yml").write "name: old\n"
    (testpath/"to.yml").write "name: new\n"
    output = shell_output("#{bin}/diffyml --color never from.yml to.yml")
    assert_match "Found one difference", output
    assert_match "+ new", output
  end
end
