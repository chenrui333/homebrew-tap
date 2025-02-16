# framework: cobra
class Ghfetch < Formula
  desc "Fetch GitHub user information and show like neofetch"
  homepage "https://github.com/orangekame3/ghfetch"
  url "https://github.com/orangekame3/ghfetch/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "ad7199da9a19d966fa88c14f5365d076661390b014653932ff7e7a39845d0431"
  license "MIT"
  head "https://github.com/orangekame3/ghfetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b93296bd439faab021d03290a9c866488ff21262da42de66cc979d8a6024ba2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "461d3a8a47a88366c0b437938a0a3adeaf54c406d79fe1f8d2f78f65d2813b53"
    sha256 cellar: :any_skip_relocation, ventura:       "3aa68fdd9475008ea5e6fac84b095f89c07e8ea1a499e8b4c43a2abeead515d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8dfd9538f2a3d58e3d53063bbaa041a8f4b136fee56d82357ddafde113a2c27"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghfetch --version")

    # Fails in Linux CI with `/dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # $ /opt/homebrew/Cellar/ghfetch/0.0.19/bin/ghfetch -u orangekame3 --access-token $GH_TOKEN
    #                ..--===++=-.
    #               .++++++++++++=
    #                 ..-==++++++#-
    #                       =#+++++       .-=+++-
    #                       .=-----.     =#+++++++
    #                    .. +++++++++==..++#++++++
    #                 -=+##-=#+##########-.=+###+.
    #               -+###+#+.+######+##+--==-=-.          User: orangekame3
    #             -+##+++##+.-==+++##+--+###+             -----------------
    #            =#++++##+=-++++====--+####+#=            Name: Takafumi Miyanaga
    #           .+++###+=-=#########=-#+######..-...      Repos: 54
    #          .======--=############.+#####+#-.###++=.   Followers: 33
    #   .----. =#+++++.+#+###########+.#######.-#++++##-  Following: 53
    #  =++++++ =+++++#=-#+###########+.-==++++ =++++++++  Total Stars Earnd: 586
    # =++++++= +++++++#-=##########+--++++===     =#+++=  Total Commit This Year: 339
    # -=--...  =++++++#= =+++####+--+#######-      ++++-  Total PRs: 288
    #          -++++++--========--+##++++#+-       -+++   Total Issues: 18
    #           =++=--=+#####++=.+#+++##+=          =+.   -----------------
    #            ..-=++++++++++#=-####+-.               ████████████████████████
    #              .=+++++++++##+.==-.
    #                 ..--=----..
    #                    .+==+-
    #                    +++++=
    #                   -+++++-
    #                   -==--.

    token = "ghp_fake1234567890"
    output = shell_output("#{bin}/ghfetch -u orangekame3 --access-token #{token} 2>&1", 1)
    assert_match "termbox: error while reading terminfo data: EOF", output
  end
end
