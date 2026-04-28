class Elastop < Formula
  desc "HTOP for Elasticsearch"
  homepage "https://github.com/acidvegas/elastop"
  url "https://github.com/acidvegas/elastop/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "d97517b9ca1f085972020a085ce51fb087afa4fc24c367952acc7dc02aa4105b"
  license "ISC"
  head "https://github.com/acidvegas/elastop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc2c8e8f926f49d966dc86eca4fe573c9e9195525f5ee906c1530b925c6acd99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3424d31a2be9527b97cd9f4ed76ddc34878dcd5b9a8e012815af98c4f194921"
    sha256 cellar: :any_skip_relocation, ventura:       "c3e596a8314f4608fd0d0f0ff0afb05b1e899b87a994cb0cf4bad348b1ccb9fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3e05c857c6de3ae3f9b16bc4e194c84f184299e3e228d3f06f105cbccefa1aa"
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
