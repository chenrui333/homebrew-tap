class Abc < Formula
  desc "Import MongoDB, SQL, JSON, CSV, Firestore, Redis Data Into Elasticsearch"
  homepage "https://github.com/appbaseio/abc"
  url "https://github.com/appbaseio/abc/archive/refs/tags/1.0.0.tar.gz"
  sha256 "d140cbb2573c4e77d8402fe6263fd866595cac27154e9981374cc716bf5f2bc0"
  license "Apache-2.0"
  head "https://github.com/appbaseio/abc.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36e4b0e0c043d2f7b795c1e30f21073f5191764d10349556421d0b443616118c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73c0293b45a3122d2d4c59107e106e539f7a69c6a2708abe714cde9588698d6d"
    sha256 cellar: :any_skip_relocation, ventura:       "4f243d347c9c940586061513c539a30e95294af598b2aea2b5209a2a8783dc70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19ae3730cebbbe1066830b8bc6300200a262261f487c50dae93f231e7c682ddd"
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
