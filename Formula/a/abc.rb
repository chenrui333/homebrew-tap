class Abc < Formula
  desc "Import MongoDB, SQL, JSON, CSV, Firestore, Redis Data Into Elasticsearch"
  homepage "https://github.com/appbaseio/abc"
  url "https://github.com/appbaseio/abc/archive/refs/tags/1.0.0.tar.gz"
  sha256 "d140cbb2573c4e77d8402fe6263fd866595cac27154e9981374cc716bf5f2bc0"
  license "Apache-2.0"
  head "https://github.com/appbaseio/abc.git", branch: "dev"

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
