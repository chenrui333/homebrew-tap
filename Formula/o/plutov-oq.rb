class PlutovOq < Formula
  desc "Terminal OpenAPI Spec viewer"
  homepage "https://github.com/plutov/oq"
  url "https://github.com/plutov/oq/archive/refs/tags/v0.0.22.tar.gz"
  sha256 "4b4b3f294482bdd45a044c5a20f0ebf5db47c6eb7906584e927ca48f3c14ecd6"
  license "MIT"
  head "https://github.com/plutov/oq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70494ca1288fe2ffffc5a94809c1056edf2d9206bda3dff4641fedc11465be29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70494ca1288fe2ffffc5a94809c1056edf2d9206bda3dff4641fedc11465be29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4d9bd677860241ff61efe3d2758de12abaecb97e1935f0b5561f4081102a28d"
    sha256 cellar: :any,                 x86_64_linux:  "1f7776103134b3d4b89fda017294dc901228454e34e878ce349c9689a5339f27"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"oq")
  end

  test do
    (testpath/"openapi.yaml").write "not: [valid\n"
    output = shell_output("#{bin}/oq #{testpath}/openapi.yaml 2>&1", 1)
    assert_match "unable to parse specification", output
  end
end
