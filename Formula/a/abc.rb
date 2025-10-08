class Abc < Formula
  desc "Import MongoDB, SQL, JSON, CSV, Firestore, Redis Data Into Elasticsearch"
  homepage "https://github.com/appbaseio/abc"
  url "https://github.com/appbaseio/abc/archive/refs/tags/1.0.0.tar.gz"
  sha256 "d140cbb2573c4e77d8402fe6263fd866595cac27154e9981374cc716bf5f2bc0"
  license "Apache-2.0"
  revision 1
  head "https://github.com/appbaseio/abc.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c8f9bfd6b795895f9a5234179074bb14de165db846538f4072ceade58ec8174"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41f969197fd33565164527e090e836319bab938b130f3a92bb69491f2af58862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "125074a71ed04fb999caad6c0733c2e20c4576a67ee58f93159a2005e6bd4ce3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50bd4ca7f6e92634322781cf74b37aab5471a553580b529f24da3f259bfbd5e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b036ca485330eb663b03517dc5117bf325989f0094cf12f62b09d50083f6a59"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/abc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abc --version")
    assert_match "Go version: go#{Formula["go"].version}", shell_output("#{bin}/abc --version")

    assert_match "user not logged in", shell_output("#{bin}/abc user")
  end
end
