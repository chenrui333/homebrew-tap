class TfstateLookup < Formula
  desc "Lookup resource attributes in tfstate"
  homepage "https://github.com/fujiwara/tfstate-lookup"
  url "https://github.com/fujiwara/tfstate-lookup/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "25cdce913064998704a8b5d26ff01a572564531999211e6c05b382f20df03f7e"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8dea786597ed9b424cb3b642971005f6121edcb0be5210f5b171d2b93c51a83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5769b9e2644e72b933284cb9445729568e144ffcc34cf18ab664482280d39dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e2196e5fe4249cae04a1795930e41b4a122ef1acb666f51f6720f84dfc415d1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tfstate-lookup"
  end

  test do
    (testpath/"terraform.tfstate").write <<~EOS
      {
        "version": 4,
        "terraform_version": "1.7.2",
        "resources": []
      }
    EOS

    output = shell_output("#{bin}/tfstate-lookup -dump")
    assert_match "{}", output
  end
end
