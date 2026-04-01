class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://github.com/Piebald-AI/splitrail"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.3.5.tar.gz"
  sha256 "2c191251c1ffc3e313655ec3f8c5c13d43355f2c4a00a3db7a94b4984b58dd00"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84f285e620597daed4ad523042857d7620789ff730becb41bee751c8367cfe55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06bfd87140332d360343c31f9371e8110e3f1ad8d4003852d9bb9461d4aec63c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58a9bdbccb46774b43473ae53fc4e06ed386656c94ab671622cee9efd86f1868"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc375eb6a416961a9789cb6d45a55c3eb920490006f67abeb5b936e6f7a0866d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eacc235cf42d88bcfa26b465720034872ffcb3385dd9c31a8ce0104e66abacd5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")
  end
end
