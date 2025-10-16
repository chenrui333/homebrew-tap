class Elastop < Formula
  desc "HTOP for Elasticsearch"
  homepage "https://github.com/acidvegas/elastop"
  url "https://github.com/acidvegas/elastop/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "d97517b9ca1f085972020a085ce51fb087afa4fc24c367952acc7dc02aa4105b"
  license "ISC"
  revision 1
  head "https://github.com/acidvegas/elastop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "489df75029f290d88542e11f01be12bc32f3e2cfbb260017c048783e91705512"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "489df75029f290d88542e11f01be12bc32f3e2cfbb260017c048783e91705512"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "489df75029f290d88542e11f01be12bc32f3e2cfbb260017c048783e91705512"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74dcba1345ace3a66abaaf032d4daa9122adf567f8e006660d300235bce9bae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4535adafd5a1c1dac63040d863b0f4c2d573b6926ae43ea3ff6dda8492bea962"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/elastop 2>&1", 1)
    assert_match "Error: Must provide either API key or both username and password", output
  end
end
