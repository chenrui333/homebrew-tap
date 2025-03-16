class Ngtop < Formula
  desc "Nginx access logs analytics"
  homepage "https://github.com/facundoolano/ngtop"
  url "https://github.com/facundoolano/ngtop/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "41fe7b63277c67f521155030e028b53ebc0649fb34919bc31785b0b3723b5c6f"
  license "GPL-3.0-only"
  head "https://github.com/facundoolano/ngtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "877c77ad4afbd58ffd2558d52c5fa36043223d556671190e88069332215c24ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d415101bb9fa8c9f88ceae9e1d9754874a6c1d12f055bdc82d33d28d7a872e92"
    sha256 cellar: :any_skip_relocation, ventura:       "ee9ab1880869282a49929646c8a3356ec962a20c75f39f564e56631a17c536f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "243e99221bdb92864259fd8dc444bdda6dc413e9fe69a570e3f074917da7224c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ngtop --version")

    assert_match <<~EOS, shell_output("#{bin}/ngtop --limit 1")
      #REQS
      0
    EOS
  end
end
