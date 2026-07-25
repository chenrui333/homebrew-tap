class Filessh < Formula
  desc "Fast and convenient TUI file browser for remote servers"
  homepage "https://github.com/JayanAXHF/filessh"
  url "https://github.com/JayanAXHF/filessh/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "c0f1bdc4bfd8ce5b09865da363966cf3fab6d2dfcdcc1b34d23965edfc474c61"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/JayanAXHF/filessh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "000fee49d1f6a5e29798cbfd81afecd12e916efec0cf35959b967505ff1b1d45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6e7073a5dac5abdf710bad66b1fb17cfe342c02ae3b7ff5dd65139160fb4952"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33bc9db3848906ea35b25b115c6c496616a2426e09694ab8937502de84b4ff1f"
    sha256 cellar: :any,                 arm64_linux:   "259158958ac81d75138f791dd4a654adc23176d304fac9a340e25e14d9a28615"
    sha256 cellar: :any,                 x86_64_linux:  "6e167db3587c2e95f821f5b9ec2837d2e7e295e5dd0779fef89bdd2d7e4252df"
  end

  depends_on "rust" => :build

  def install
    ENV["VERGEN_GIT_BRANCH"] = "main"
    ENV["VERGEN_GIT_COMMIT_TIMESTAMP"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filessh --version")
    assert_match "You must provide a host", shell_output("#{bin}/filessh connect 2>&1", 1)
  end
end
