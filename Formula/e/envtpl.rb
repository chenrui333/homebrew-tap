class Envtpl < Formula
  desc "Render Go templates on the command-line with shell environment variables"
  homepage "https://github.com/chenrui333/envtpl"
  url "https://github.com/chenrui333/envtpl/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "162e968db5149c57996d79b38ae78ccebb6b551a16d77cc3075c2ba897b68fdb"
  license "MIT"
  head "https://github.com/chenrui333/envtpl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "631c7c0ee3790fe5352d472640c36018be1cdd8f957b1b1e976d9670a4227c65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da01ad707ffb148f59889dd475bc6f16b5f118df38f75297aafa6d8cd50e0954"
    sha256 cellar: :any_skip_relocation, ventura:       "177004d5ba30a049f791c038be5106384912e3b3fff1d085496574fc1e2b661c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8284118f17fb923b5da1d368a28068723095ca377f8f0aa2d20860a245cac1f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/envtpl"
  end

  test do
    system bin/"envtpl", "--version"

    # test envtpl with a template file
    (testpath/"test.tmpl").write <<~EOS
      Hello, {{ .ENV_NAME }}!
    EOS
    assert_match "Hello, Homebrew!", shell_output("ENV_NAME=Homebrew #{bin}/envtpl test.tmpl")
  end
end
