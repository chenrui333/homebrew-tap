class Pmx < Formula
  desc "Manage and switch between AI agent profiles across different platforms"
  homepage "https://github.com/NishantJoshi00/pmx"
  url "https://github.com/NishantJoshi00/pmx/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "14bc6207dc78cf96831feee9ee3ddc712084c92350213500c4320383544a5286"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32cd06caf8c3e0e4517738a818023a38509c9fcf82cfc84ebbe00e50a5cc20bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ac0e3a10bab8dd1937c13a9e81f8759d043d97ec5317012cefca61e0d026a4c"
    sha256 cellar: :any_skip_relocation, ventura:       "4e93c2aa522aa71ea66455096cd688cb3004a864bb568433f7f714affcaff350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3462645573465d072b8c7075e5435397745fda76dbb84667cb37396d788163e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    completion_file = zsh_completion/"_pmx"
    rm completion_file if completion_file.exist?
    generate_completions_from_executable(bin/"pmx", "completion", shells: [:zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pmx --version")
    output = shell_output("#{bin}/pmx profile list")
    assert_match "No profiles found", output
  end
end
