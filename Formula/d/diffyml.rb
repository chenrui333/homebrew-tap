class Diffyml < Formula
  desc "Structural YAML diff tool with Kubernetes intelligence"
  homepage "https://github.com/szhekpisov/diffyml"
  url "https://github.com/szhekpisov/diffyml/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "38f188dc938a29b950d936765f8a1cf5b4eeb81379f8c682b32b79bf46f1afec"
  license "MIT"
  head "https://github.com/szhekpisov/diffyml.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac1060bd6018fff22614b5b2625953b65992cdbcaac36c015a579f9d7109467f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac1060bd6018fff22614b5b2625953b65992cdbcaac36c015a579f9d7109467f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac1060bd6018fff22614b5b2625953b65992cdbcaac36c015a579f9d7109467f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb085f66207602d7d524063ff99e6f6918d1cf36628d818656f5ee3c9f4654cb"
    sha256 cellar: :any,                 x86_64_linux:  "15be4d130d8c05a9821847c2321a798a1a78f92b3a3f2d4ef22a207ee55939ce"
  end

  depends_on "go" => :build

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
