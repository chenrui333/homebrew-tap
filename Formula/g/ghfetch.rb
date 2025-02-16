# framework: cobra
class Ghfetch < Formula
  desc "Fetch GitHub user information and show like neofetch"
  homepage "https://github.com/orangekame3/ghfetch"
  url "https://github.com/orangekame3/ghfetch/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "ad7199da9a19d966fa88c14f5365d076661390b014653932ff7e7a39845d0431"
  license "MIT"
  head "https://github.com/orangekame3/ghfetch.git", branch: "main"

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
