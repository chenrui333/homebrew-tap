class Pam < Formula
  desc "Minimal CLI tool for managing and executing SQL queries with a TUI"
  homepage "https://github.com/eduardofuncao/squix"
  url "https://github.com/eduardofuncao/squix/archive/refs/tags/v0.4.2-beta.tar.gz"
  sha256 "2cfcd962db5d233813fa6888212ef4276dc9999872c358bcaa4d54f3540f2535"
  license "MIT"
  head "https://github.com/eduardofuncao/squix.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-beta)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "671248eca625a31a87a33401b7b3439cfd9844bf447d383fed9530ff532e0ea1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cd475bcaa369a9e8ae280399dd9ae15768b418b9e3fbc4b8b8b9c4e5d2b9852"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab9c6da4686482443e64e02ab8f398c1ba52bc2a5d86ec68383c1ace3fec0bfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "143e38a98c401057dfd5e76d9859676dd288d31fd7fd774d126c874b68dee4ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a3681225c93b5e2d4c566db1e4251f85b2207412c6ed0afa39a5f861cff8e3d"
  end

  depends_on "go" => :build

  def install
    # Upstream renamed the project from pam to squix; keep a pam shim for this tap formula name.
    system "go", "build", *std_go_args(output: bin/"squix", ldflags: "-s -w"), "./cmd/squix"
    bin.install_symlink "squix" => "pam"
  end

  test do
    output = shell_output("#{bin}/pam list connections")
    assert_match "No connections configured", output
    assert_equal shell_output("#{bin}/squix --version").strip, shell_output("#{bin}/pam --version").strip
  end
end
