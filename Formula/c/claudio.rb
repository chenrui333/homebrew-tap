class Claudio < Formula
  desc "Hook-based audio plugin for Claude Code that plays contextual sounds"
  homepage "https://github.com/ctoth/claudio"
  url "https://github.com/ctoth/claudio/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "257bc0153d1a83a4df6a2eb5d0537adc7a001cf3cfec59f7588c48dd8243e964"
  head "https://github.com/ctoth/claudio.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e28257299fad782aea75032c7394099d786e45113da57f96357c5cde29af8b2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6193912f5f11f2e64de3c2a7586ac21c176d9286d0a59cadd2376634ccf706cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ac495412f9a4d4feb89538e565feee785353dcca01ce09d66b3c04b9e54caf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffc246801db603b68f61b69348b7a70440d417c4d25048b32c138055b384e76d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f18a4924e9b7411c28f6c692ed4d545e76ea403b4add6a37914d99909f7ce67"
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
