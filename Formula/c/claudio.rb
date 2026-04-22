class Claudio < Formula
  desc "Hook-based audio plugin for Claude Code that plays contextual sounds"
  homepage "https://github.com/ctoth/claudio"
  url "https://github.com/ctoth/claudio/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "be23354b5cdecf4e24b5da36e8b3b3352e68eaf27e97545505ca1f25a4dd57ad"
  head "https://github.com/ctoth/claudio.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e13a9f9b36f1663ce3ca6459680c6d4e4fb8b487050810b727982c1e79095ed2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1917aa3f1d35c8ccf0e5da11389541556bc36589dfb4647a38943d924a0a884"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6769abe8ff3bf3baf9c0ef65c06666bfa711786ecd653bc62878a1f894fe8729"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c8a94938b8a7a2577a3ab48ffb5b8fec761ed629b0db3fbac08955acc2675e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c68e4469106f1e8d09c07e103f6c111020e46e1002db23cac65549e411e79edd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/claudio"

    generate_completions_from_executable(bin/"claudio", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claudio --version")
    output = shell_output("#{bin}/claudio analyze usage")
    assert_match "No sound usage data found for the specified criteria", output
  end
end
