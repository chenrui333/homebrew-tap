class Elastop < Formula
  desc "HTOP for Elasticsearch"
  homepage "https://github.com/acidvegas/elastop"
  url "https://github.com/acidvegas/elastop/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "d97517b9ca1f085972020a085ce51fb087afa4fc24c367952acc7dc02aa4105b"
  license "ISC"
  head "https://github.com/acidvegas/elastop.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/elastop 2>&1", 1)
    assert_match "Error: Must provide either API key or both username and password", output
  end
end
