class Hexowl < Formula
  desc "Lightweight, flexible programmer's calculator with variables and functions"
  homepage "https://hexowl.ru/"
  url "https://github.com/DECE2183/hexowl/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "c80e419d8936b610d414f374f909d3dc5dc6b53a95ebf3589ecae6618814fed8"
  license "GPL-3.0-or-later"
  head "https://github.com/dece2183/hexowl.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f531da5e0122c1e048ceb06e955e0a115fe30a161b0d2f0a7b1a19bd2e08915a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46062207f884edf40609e61b4469c1594c525f1393e5a1a679d5a4d905897329"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33567f50dc9605fa11660dcf8cb48bbf50656b82e546005f104301b12a25a248"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0810928411493b9fb8547af79dc00fbc2aedde8b559803d147f771d90bf5aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdd3578212563b9d15e51890d78c3ef3e8eac0ab9b554f44c6086d948b92c6c5"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hexowl version")
    assert_match "funcs", shell_output("#{bin}/hexowl funcs")
  end
end
