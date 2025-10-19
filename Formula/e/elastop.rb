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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b67ef016e584156b41e1d243fc1ce5d55933906095c704f37d05cbac28b515f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b67ef016e584156b41e1d243fc1ce5d55933906095c704f37d05cbac28b515f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b67ef016e584156b41e1d243fc1ce5d55933906095c704f37d05cbac28b515f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2656c74b66ba8861ae9128656dfdc5c3d08c8c724ca986631270f8a6f27c59d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74633176205d935a845abe8c6282d2a20b2e90683bc9119e707e67ea1b949ea3"
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
