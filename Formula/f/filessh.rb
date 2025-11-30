class Filessh < Formula
  desc "Fast and convenient TUI file browser for remote servers"
  homepage "https://github.com/JayanAXHF/filessh"
  url "https://github.com/JayanAXHF/filessh/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "eb55fec4978b5f91149d6d555d15cbb47ceff6d0da5c0dc29b41ca0641e5379b"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/JayanAXHF/filessh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b76ad93c64eced2f03a8c1bc819b550633cc481359d6f26b8098b59936d06695"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "217791f822bb5eabadced095112dfcf617de9350c28af96db615ad683377c13a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe3d88b8e3f682c1f69a1b67478333fdfef35b173916b70212788a4404ecd05f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b4290ebebe2172bd7f149d253727a72f76fbcc7fd55c31d3e856383e5b1137e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1038cb09659d885a5b67077004c0e24b00a803bf98ec9c4d592cac664b519dcc"
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
