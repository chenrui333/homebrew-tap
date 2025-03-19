class Plandex < Formula
  desc "AI driven development in your terminal. Designed for large, real-world tasks"
  homepage "https://plandex.ai/"
  url "https://github.com/plandex-ai/plandex/archive/refs/tags/cli/v2.0.0.tar.gz"
  sha256 "d65f81090407ed63b0fe8bb93aa46808b581b6e58f20a50e900d098bcbd1ffb9"
  license "MIT"
  head "https://github.com/plandex-ai/plandex.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1670e3dcecb566a60d3ad34e3963c254911938f533f302e91a4f9e92229868e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d357735c7c1c56027902fb2808eb34c366cd3087043f5858ce2b9a30b3f3e4d"
    sha256 cellar: :any_skip_relocation, ventura:       "43d740aef2a8d941dde28ae620d6f63b81b834a86be6ccf052f9ff209a9ffe0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baa9c77dbc4773cc3b2d6289b89ced169b49495385ec1fcc1f2dee6f44d736b8"
  end

  depends_on "go" => :build

  def install
    cd "app/cli" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X plandex-cli/version.Version=#{version}")
      generate_completions_from_executable(bin/"plandex", "completion")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plandex version")
    system bin/"plandex"
  end
end
